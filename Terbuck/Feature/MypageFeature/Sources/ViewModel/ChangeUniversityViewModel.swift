//
//  ChangeUniversityViewModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import Combine

import Shared

enum ChangeUniversityError: LocalizedError, Equatable {
    case notUniversity
    case serverFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .notUniversity:
            return "대학교가 선택되지 않았어요."
        case .serverFailed:
            return "다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public class ChangeUniversityViewModel {
    
    // MARK: - Properties
    
    private var changeUniversityUseCase: ChangeUniversityUseCase
    var universityName: String? = nil
    
    // MARK: - Private Combine Publishers Properties
    
    private let selectedUniversitySubject = CurrentValueSubject<University?, Never>(nil)
    private let changeUniversityErrorSubject = PassthroughSubject<ChangeUniversityError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    let universitySubject = CurrentValueSubject<String?, Never>(nil)
    var changeUniversityError: AnyPublisher<ChangeUniversityError, Never> {
        changeUniversityErrorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    
    struct Input {
        let universityTapped: AnyPublisher<University, Never>
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedUniversity: AnyPublisher<University?, Never>
        let bottomButtonResult: AnyPublisher<Void, Never>
        let changeUniversityError: AnyPublisher<ChangeUniversityError, Never>
    }
    
    // MARK: - Init
    
    public init(
        changeUniversityUseCase: ChangeUniversityUseCase
    ) {
        self.changeUniversityUseCase = changeUniversityUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.universityTapped
            .sink { [weak self] tapped in
                guard let self = self else { return }

                if self.selectedUniversitySubject.value == tapped {
                    self.selectedUniversitySubject.send(nil)
                    universityName = nil
                } else {
                    self.selectedUniversitySubject.send(tapped)
                    let name = tapped == .kw ? "광운대학교" : "서울과학기술대학교"
                    universityName = name
                }
            }
            .store(in: &cancellables)
        
        let bottomButtonResult = input.bottomButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                guard let name = universityName else {
                    self.changeUniversityErrorSubject.send(.notUniversity)
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.changeUniversityPublisher(name)
                    .handleEvents(receiveCompletion: { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.changeUniversityErrorSubject.send(error)
                        }
                    })
                    .map { _ in () }
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
        
        return Output(
            selectedUniversity: selectedUniversitySubject.eraseToAnyPublisher(),
            bottomButtonResult: bottomButtonResult.eraseToAnyPublisher(),
            changeUniversityError: changeUniversityError
            
        )
    }
}

// MARK: - Private API Extension

private extension ChangeUniversityViewModel {
    func changeUniversityPublisher(_ university: String) -> AnyPublisher<Void, ChangeUniversityError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let _ = try await self.changeUniversityUseCase.execute(university: university)
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
