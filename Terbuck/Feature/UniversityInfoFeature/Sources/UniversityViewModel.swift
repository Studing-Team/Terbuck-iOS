//
//  UniversityViewModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import Foundation
import Combine

import Shared

enum UniversityError: LocalizedError, Equatable {
    case signupFailed
    case editUniversityFailed
    case notEditUniversity
    case unknown

    var errorDescription: String? {
        switch self {
        case .signupFailed:
            return "회원가입에 실패했습니다."
        case .editUniversityFailed:
            return "대학교를 변경하지 못했습니다."
        case .notEditUniversity:
            return "대학교를 변경할 수 없습니다"
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public class UniversityViewModel {
    
    // MARK: - Properties
    
    private var signupUseCase: SignupUseCase?
    private var editUniversityUseCase: EditUniversityUseCase?
    
    var universityName: String? = nil
    
    // MARK: - Private Combine Publishers Properties
    
    private let selectedUniversitySubject = CurrentValueSubject<University?, Never>(nil)
    private let errorSubject = PassthroughSubject<UniversityError, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let universityTapped: AnyPublisher<University, Never>
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedUniversity: AnyPublisher<University?, Never>
        let errorResult: AnyPublisher<UniversityError, Never>
        let bottomButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Init
    
    public init(
        signupUseCase: SignupUseCase? = nil,
        editUniversityUseCase: EditUniversityUseCase? = nil
    ) {
        self.signupUseCase = signupUseCase
        self.editUniversityUseCase = editUniversityUseCase
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
        
        let bottomButtonResult = input.bottomButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else {
                    return Just(false).eraseToAnyPublisher()
                }
                
                if let _ = self.signupUseCase, let universityName = self.universityName {
                    return self.signupPublisher(universityName)
                        .map { _ in
                            UserDefaultsManager.shared.set(universityName, for: .university)
                            return true
                        }
                        .catch { _ in Just(false) }
                        .eraseToAnyPublisher()
                }
                
                if let _ = self.editUniversityUseCase, let universityName = self.universityName {
                    return editUniversityPublisher(universityName)
                        .map { _ in
                            UserDefaultsManager.shared.set(false, for: .isStudentIDAuthenticated)
                            UserDefaultsManager.shared.set(universityName, for: .university)
                            FileStorageManager.shared.delete(type: .studentIdCard)
                            return true
                        }
                        .catch { error in
                            self.errorSubject.send(error)
                            return Just(false)
                        }
                        .eraseToAnyPublisher()
                }
                
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            selectedUniversity: selectedUniversitySubject.eraseToAnyPublisher(),
            errorResult: errorSubject.eraseToAnyPublisher(),
            bottomButtonResult: bottomButtonResult
        )
    }
}

// MARK: - Private API methods

private extension UniversityViewModel {
    func signupPublisher(_ university: String) -> AnyPublisher<Void, UniversityError> {
        return Future { [weak self] promise in
            guard let self, let signupUseCase else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    _ = try await signupUseCase.execute(university: university)
                    promise(.success(()))
                } catch {
                    promise(.failure(.signupFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func editUniversityPublisher(_ university: String) -> AnyPublisher<Void, UniversityError> {
        return Future { [weak self] promise in
            guard let self, let editUniversityUseCase else {
                promise(.failure(.unknown))
                return
            }
            
            if university == UserDefaultsManager.shared.string(for: .university) {
                promise(.failure(.notEditUniversity))
                return
            }
            
            Task {
                do {
                    let _ = try await editUniversityUseCase.execute(university: university)
                    promise(.success(()))
                } catch {
                    promise(.failure(.editUniversityFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
