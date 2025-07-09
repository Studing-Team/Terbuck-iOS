//
//  AlarmSettingViewModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import Combine
import UserNotifications

import Shared


public final class AlarmSettingViewModel {
    
    // MARK: - Combine Publishers Properties
    
    public var isAlarmOnSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<Bool, Never>
    }
    
    public init() { }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ in
                guard let self else {
                    return Just(false).eraseToAnyPublisher()
                }
                
                return self.checkNotificationStatus()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult
        )
    }
}

// MARK: - Private Methods Extension

private extension AlarmSettingViewModel {
    func checkNotificationStatus() -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { promise in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let isEnabled = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
                promise(.success(isEnabled))
            }
        }
        .eraseToAnyPublisher()
    }
}
