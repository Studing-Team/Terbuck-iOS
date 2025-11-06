//
//  UniversityViewModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import Foundation
import Combine
import Observation

import Shared
import UniversityInfoInterface

enum UniversityError: LocalizedError, Equatable {
    case fetchFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "대학교 정보를 불러올 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

@Observable
public class UniversityViewModel {
    
    // MARK: - Properties
    
    private var getUniversityInfoListUseCase: any GetUniversityInfoListUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private let selectedUniversitySubject = CurrentValueSubject<String?, Never>(nil)

    private let errorSubject = PassthroughSubject<UniversityError, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - SwiftUI Published Properties
    
    var selectedItemForUI: String?
    var universityInfoModel: [UniversityInfoModel]?
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
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
        getUniversityInfoListUseCase: any GetUniversityInfoListUseCase
    ) {
        self.getUniversityInfoListUseCase = getUniversityInfoListUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.viewLifeCycleEventAction
            .filter { $0 == .viewDidLoad }
            .flatMap { [weak self] _ -> AnyPublisher<[UniversityInfoModel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                
                return self.fetchUniversityPublisher()
                    .catch { [weak self] error -> Just<[UniversityInfoModel]> in
                        self?.errorSubject.send(error)
                        return Just([])
                    }
                    .eraseToAnyPublisher()
            }
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] universityInfo in
                self?.universityInfoModel = universityInfo
            }
            .store(in: &cancellables)
        
        
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


// MARK: - Private methods

private extension UniversityViewModel {
    func convertToModel(_ entities: [UniversityInfoEntity]) -> [UniversityInfoModel] {
        return entities.map {
            UniversityInfoModel(
                id: $0.id,
                title: $0.regionName,
                items: $0.universityNames
            )
        }
    }
}

// MARK: - Private API methods

private extension UniversityViewModel {
    func fetchUniversityPublisher() -> AnyPublisher<[UniversityInfoModel], UniversityError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let entities = try await self.getUniversityInfoListUseCase.execute()
                    let models = self.convertToModel(entities)
                    promise(.success(models))
                } catch {
                    promise(.failure(.fetchFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
