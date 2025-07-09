//
//  StudentIdCardViewModel.swift
//  RegisterStudentCardFeature
//
//  Created by ParkJunHyuk on 6/20/25.
//

import Foundation
import Combine

import CoreNetwork
import Shared


enum StudentIdCardError: LocalizedError, Equatable {
    case studentIdCardFailed
    case unknown

    var errorDescription: String {
        switch self {
        case .studentIdCardFailed:
            return "학생증 이미지를 받아올 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public final class StudentIdCardViewModel {
 
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<Data, Never>

    }
    
    // MARK: - Init
    
    public init(
       
    ) {
        
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ -> AnyPublisher<Data, Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }

                if let imageData = FileStorageManager.shared.load(type: .studentIdCard) {
                    return Just(imageData)
                        .eraseToAnyPublisher()
                } else {
                    // 없으면 API 호출 후 Data 반환
                    return self.loadStudentIdCardPublisher()
                        .handleEvents(receiveOutput: { imageData in
                            let _ = FileStorageManager.shared.saveData(data: imageData, type: .studentIdCard)
                        })
                        .catch { _ in Empty() } // 실패하면 빈 스트림 방출
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult
        )
    }
}

// MARK: - Private API Extension

private extension StudentIdCardViewModel {
    func loadStudentIdCardPublisher() -> AnyPublisher<Data, StudentIdCardError> {
        return Future { promise in
            guard let imageURL = UserDefaultsManager.shared.string(for: .studentIdCardImageURL) else {
                promise(.failure(.studentIdCardFailed))
                return
            }
            
            guard let url = URL(string: imageURL) else {
                promise(.failure(.studentIdCardFailed))
                return
            }
            
            Task {
                do {
                    let imageData = try await NetworkManager.shared.requestImage(url: url)
                    promise(.success(imageData))
                } catch {
                    promise(.failure(.studentIdCardFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
