//
//  UniversityViewModel.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation
import Combine

import Shared

enum SignupError: LocalizedError, Equatable {
    case signupFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .signupFailed:
            return "회원가입에 실패했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public class UniversityViewModel {
    
    // MARK: - Properties
    
    var signupUseCase: SignupUseCase
    var universityName: String? = nil
    
    // MARK: - Combine Publishers Properties
    
    private let selectedUniversitySubject = CurrentValueSubject<University?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let universityTapped: AnyPublisher<University, Never>
        let signupButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedUniversity: AnyPublisher<University?, Never>
        let signupButtonResult: AnyPublisher<Result<Void, SignupError>, Never>
    }
    
    // MARK: - Init
    
    public init(
        signupUseCase: SignupUseCase
    ) {
        self.signupUseCase = signupUseCase
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
                    universityName = tapped.title//name
                }
            }
            .store(in: &cancellables)
        
        let signupResult = input.signupButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, SignupError> , Never> in
                guard let self else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                }
                
                guard let name = universityName else {
                    return Just(.failure(.unknown))
                        .eraseToAnyPublisher()
                }
                
                return self.signupPublisher(name)
                    .handleEvents(receiveOutput: { _ in
                        UserDefaults.standard.set(name, forKey: "University")
                    })
                    .map {
                        .success(())
                    }
                    .catch {
                        Just(.failure($0))
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        
        return Output(
            selectedUniversity: selectedUniversitySubject.eraseToAnyPublisher(),
            signupButtonResult: signupResult
        )
    }
}

// MARK: - Private API methods

private extension UniversityViewModel {
    func signupPublisher(_ university: String) -> AnyPublisher<Void, SignupError> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    _ = try await self.signupUseCase.execute(university: university)
                    promise(.success(()))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
