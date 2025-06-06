//
//  RegisterStudentCardViewModel.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 6/3/25.
//

import Foundation
import Combine

import Shared

enum StudentCardError: LocalizedError, Equatable {
    case serverFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .serverFailed:
            return "다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public final class RegisterStudentCardViewModel {
    
    // MARK: - Properties
    
    private let registerStudentIDUseCase: RegisterStudentIDUseCase
    private var studentName: String?
    private var studentId: String?
    private var studentImageData: Data?
    
    // MARK: - Private Combine Publishers Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let registerStudentIdImage: AnyPublisher<Data, Never>
        let registerStudentName: AnyPublisher<String, Never>
        let registerStudentId: AnyPublisher<String, Never>
        let registerStudentIDCardButtonTapped: AnyPublisher<Void, Never>
        let bottomButtonTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let registerStudentIDCardButtonResult: AnyPublisher<Void, Never>
        let registerBottomButtonResult: AnyPublisher<Bool, Never>
        let buttonButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Init
    
    public init(
        registerStudentIDUseCase: RegisterStudentIDUseCase
    ) {
        self.registerStudentIDUseCase = registerStudentIDUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let mergeRegisterInput = Publishers.CombineLatest3(
            input.registerStudentName,
            input.registerStudentId,
            input.registerStudentIdImage
        )
        .map { name, id, imageData -> Bool in
            return !name.isEmpty && !id.isEmpty && !imageData.isEmpty
        }
        
        input.registerStudentName
            .sink { [weak self] name in
                self?.studentName = name
            }
            .store(in: &cancellables)

        input.registerStudentId
            .sink { [weak self] id in
                self?.studentId = id
            }
            .store(in: &cancellables)

        input.registerStudentIdImage
            .sink { [weak self] imageData in
                self?.studentImageData = imageData
            }
            .store(in: &cancellables)
        
        let registerBottomButtonResult = input.bottomButtonTapped
            .flatMap { [weak self] in
                guard let self = self else {
                    return Just(false).eraseToAnyPublisher()
                }

                return self.putStudentCardPublisher()
                    .catch { _ in Just(false).eraseToAnyPublisher() }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            registerStudentIDCardButtonResult: input.registerStudentIDCardButtonTapped,
            registerBottomButtonResult: mergeRegisterInput.eraseToAnyPublisher(),
            buttonButtonResult: registerBottomButtonResult.eraseToAnyPublisher()
        )
    }
}

// MARK: - Private API Extension

private extension RegisterStudentCardViewModel {
    func putStudentCardPublisher() -> AnyPublisher<Bool, StudentCardError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            guard let studentImageData, let studentName, let studentId else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let _ = try await self.registerStudentIDUseCase.execute(
                        imageData: studentImageData,
                        studentName: studentName,
                        studentId: studentId
                    )
                    
                    promise(.success(true))
                } catch {
                    promise(.failure(.serverFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
