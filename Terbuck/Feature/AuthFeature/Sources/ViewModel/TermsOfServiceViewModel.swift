//
//  TermsOfServiceViewModel.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/26/25.
//

import Foundation
import Combine

public class TermsOfServiceViewModel {
    
    // MARK: - Properties

    
    // MARK: - Combine Publishers Properties

    let serviceTermsSubject = CurrentValueSubject<Bool, Never>(false)
    let userInfoTermsSubject = CurrentValueSubject<Bool, Never>(false)
    let allTermsCheckSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let serviceTermsTapped: AnyPublisher<Bool, Never>
        let userInfoTermsTapped: AnyPublisher<Bool, Never>
        let allTermsTapped: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let serviceTermsResult: AnyPublisher<Bool, Never>
        let userInfoTermsResult: AnyPublisher<Bool, Never>
        let allTermsResult: AnyPublisher<Bool, Never>
        let mergeTermsResult: AnyPublisher<Bool, Never>
        let isBottomButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Init
    
    public init(
        
    ) {
        
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.serviceTermsTapped
            .sink { [weak self] value in
                guard let self else { return }
                
                self.serviceTermsSubject.send(value)
                print("isServiceTerms:", self.serviceTermsSubject.value)
            }
            .store(in: &cancellables)
        
        input.userInfoTermsTapped
            .sink { [weak self] value in
                guard let self else { return }
                self.userInfoTermsSubject.send(value)

                print("isUserInfoTerms:", self.userInfoTermsSubject.value)
            }
            .store(in: &cancellables)
        
        input.allTermsTapped
            .sink { [weak self] _ in
                guard let self else { return }
                let isAllTrems = !self.allTermsCheckSubject.value
                
                allTermsCheckSubject.send(isAllTrems)
                serviceTermsSubject.send(isAllTrems)
                userInfoTermsSubject.send(isAllTrems)

            }
            .store(in: &cancellables)
        
        let mergeTermsResult = Publishers.CombineLatest(
            serviceTermsSubject,
            userInfoTermsSubject
        )
        .map { service, userInfo in
            let allChecked = service && userInfo
            self.allTermsCheckSubject.send(allChecked)
            return allChecked
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
        
        
        let isButtonEnabled = Publishers.CombineLatest(
            serviceTermsSubject,
            userInfoTermsSubject
        )
        .map { service, userInfo in
            return service && userInfo
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
        
        return Output(
            serviceTermsResult: serviceTermsSubject.eraseToAnyPublisher(),
            userInfoTermsResult: userInfoTermsSubject.eraseToAnyPublisher(),
            allTermsResult: allTermsCheckSubject.eraseToAnyPublisher(),
            mergeTermsResult: mergeTermsResult,
            isBottomButtonEnabled: isButtonEnabled
        )
    }
}
