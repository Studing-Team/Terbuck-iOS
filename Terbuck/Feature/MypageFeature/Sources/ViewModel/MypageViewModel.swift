//
//  MypageViewModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import Combine

public final class MypageViewModel {
    
    // MARK: - Combine Publishers Properties
    
    private let navigationEventSubject = PassthroughSubject<MypageNavigationType, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    struct Input {
        let selectedCell: AnyPublisher<(section: MyPageType, index: Int), Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let navigationEvent: AnyPublisher<MypageNavigationType, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.selectedCell
            .sink { [weak self] section, index in
                guard let self else { return }
                
                self.selectCellHandler(section: section, index: index)
            }
            .store(in: &cancellables)
        
        return Output(
            navigationEvent: navigationEventSubject.eraseToAnyPublisher()
        )
    }
}

// MARK: - Private Methods Extension

private extension MypageViewModel {
    private func selectCellHandler(section: MyPageType, index: Int) {
        switch section {
        case .userInfo:
            break

        case .alarmSetting:
            navigationEventSubject.send(.alarmSetting)

        case .appService:
            switch index {
            case 0: navigationEventSubject.send(.inquiry)
            case 1: navigationEventSubject.send(.serviceGuide)
            case 2: navigationEventSubject.send(.privacyPolicy)
            default: break
            }

        case .userAuth:
            switch index {
            case 0: navigationEventSubject.send(.showLogout)
            case 1: navigationEventSubject.send(.withdraw)
            default: break
            }
        }
    }
}
