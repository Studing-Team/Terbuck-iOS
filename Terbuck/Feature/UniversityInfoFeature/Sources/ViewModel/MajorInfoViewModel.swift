//
//  MajorInfoViewModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import Foundation
import Combine

import Shared

public class MajorInfoViewModel: ObservableObject {
    
    // MARK: - Properties
    
    
    
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
        selectedUniversityName: String
    ) {
        self.selectedUniversityNameSubject.send(selectedUniversityName)
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let isBottomButtonEnabled = selectedMajorSubject
            .map { selectedItem in
                selectedItem == nil ? false : true
            }
            .eraseToAnyPublisher()
        
        let bottomButtonResult = input.bottomButtonTapped
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
    
}
