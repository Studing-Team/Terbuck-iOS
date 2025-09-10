//
//  MajorInfoViewModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import Foundation
import Combine

import Shared

enum MajorError: LocalizedError, Equatable {
    case fetchFailed
    case signupFailed
    case notEditUniversity
    case editUniversityFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "대학교 단과대 정보를 불러올 수 없습니다."
        case .signupFailed:
            return "가입 관련해서 문제가 발생했어요."
        case .notEditUniversity:
            return "대학교 인증 문제가 발생했어요."
        case .editUniversityFailed:
            return "대학교 변경 관련해서 문제가 발생했어요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public class MajorInfoViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var signupUseCase: SignupUseCase?
    private var editUniversityUseCase: EditUniversityUseCase?
    
    // MARK: - Private Combine Publishers Properties
    
    public let selectedUniversityNameSubject = CurrentValueSubject<String, Never>("")
    private let selectedMajorSubject = CurrentValueSubject<String?, Never>(nil)
    
    // MARK: - Private Combine Publishers Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - SwiftUI Published Properties
    
    @Published var selectedItemForUI: String?
    
    // MARK: - Input
    
    struct Input {
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isBottomButtonEnabled: AnyPublisher<Bool, Never>
        let bottomButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Init
    
    public init(
        selectedUniversityName: String,
        signupUseCase: SignupUseCase? = nil,
        editUniversityUseCase: EditUniversityUseCase? = nil,
    ) {
        self.selectedUniversityNameSubject.send(selectedUniversityName)
        self.signupUseCase = signupUseCase
        self.editUniversityUseCase = editUniversityUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let isBottomButtonEnabled = selectedMajorSubject
            .map { selectedItem in
                selectedItem == nil ? false : true
            }
            .eraseToAnyPublisher()
        
        let bottomButtonResult = input.bottomButtonTapped
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false)
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else {
                    return Just(false).eraseToAnyPublisher()
                }
                
                return Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            isBottomButtonEnabled: isBottomButtonEnabled,
            bottomButtonResult: bottomButtonResult
        )
    }
}

// MARK: - Public Methods

public extension MajorInfoViewModel {
    func selectItem(_ item: String?) {
        if selectedItemForUI == item {
            selectedItemForUI = nil
            selectedMajorSubject.send(nil)
        } else {
            selectedItemForUI = item
            selectedMajorSubject.send(item)
        }
    }
}

// MARK: - Private API methods

private extension MajorInfoViewModel {
    func signupPublisher(_ university: String) -> AnyPublisher<Void, MajorError> {
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
    
    func editUniversityPublisher(_ university: String) -> AnyPublisher<Void, MajorError> {
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
