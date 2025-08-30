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

public class UniversityViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var signupUseCase: SignupUseCase?
    private var editUniversityUseCase: EditUniversityUseCase?
    
    var universityName: String? = nil
    
    // MARK: - Private Combine Publishers Properties
    
    private let selectedUniversitySubject = CurrentValueSubject<String?, Never>(nil)

    private let errorSubject = PassthroughSubject<UniversityError, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - SwiftUI Published Properties
    
    @Published var selectedItemForUI: String?
    
    // MARK: - Input
    
    struct Input {
//        let universityTapped: AnyPublisher<String?, Never>
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let errorResult: AnyPublisher<UniversityError, Never>
        let isBottomButtonEnabled: AnyPublisher<Bool, Never>
        let bottomButtonResult: AnyPublisher<String, Never>
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
        let isBottomButtonEnabled = selectedUniversitySubject
            .map { selectedItem in
                selectedItem == nil ? false : true
            }
            .eraseToAnyPublisher()
        
        let bottomButtonResult = input.bottomButtonTapped
            .compactMap { [weak self] _ in
                self?.selectedItemForUI
            }
            .eraseToAnyPublisher()
        
        return Output(
            errorResult: errorSubject.eraseToAnyPublisher(),
            isBottomButtonEnabled: isBottomButtonEnabled,
            bottomButtonResult: bottomButtonResult
        )
    }
}

// MARK: - Public Methods

public extension UniversityViewModel {
    func selectItem(_ item: String?) {
        if selectedItemForUI == item {
            selectedItemForUI = nil
            selectedUniversitySubject.send(nil)
        } else {
            selectedItemForUI = item
            selectedUniversitySubject.send(item)
        }
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
