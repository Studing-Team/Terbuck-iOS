//
//  MypageViewModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import Foundation
import Combine

import Shared

enum MypageError: LocalizedError, Equatable {
    case studentInfoFailed
    case unknown

    var errorDescription: String {
        switch self {
        case .studentInfoFailed:
            return "유저 정보를 불러올 수 없어요."
        case .unknown:
            return "알 수 없는 오류가 발생했어요."
        }
    }
}

public final class MypageViewModel {
    
    // MARK: - Properties
    
    private var searchStudentInfoUseCase: SearchStudentInfoUseCase
    
    // MARK: - Private Combine Publishers Properties
    
    private let navigationEventSubject = PassthroughSubject<MypageNavigationType, Never>()
    private let searchStudentInfoErrorSubject = PassthroughSubject<MypageError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Combine Publishers Properties
    
    var searchStudentInfoError: AnyPublisher<MypageError, Never> {
        searchStudentInfoErrorSubject.eraseToAnyPublisher()
    }
    
    let userInfoModelSubject = CurrentValueSubject<UserInfoModel?, Never>(nil)
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let selectedCell: AnyPublisher<(section: MyPageType, index: Int), Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let searchStudentInfoResult: AnyPublisher<Void, Never>
        let navigationEvent: AnyPublisher<MypageNavigationType, Never>
        let searchStudentInfoError: AnyPublisher<MypageError, Never>
    }
    
    // MARK: - Init
    
    public init(
        searchStudentInfoUseCase: SearchStudentInfoUseCase
    ) {
        self.searchStudentInfoUseCase = searchStudentInfoUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let searchResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.searchMyInfoPublisher()
                    .handleEvents(receiveOutput: { [weak self] model in
                        self?.userInfoModelSubject.send(model) // ✅ 상태 업데이트
                    }, receiveCompletion: { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?.searchStudentInfoErrorSubject.send(error) // ✅ 에러 전달
                        }
                    })
                    .map { _ in () } // ✅ 의미 없는 Void 값으로 변환
                    .catch { _ in Empty() } // ✅ 에러 발생해도 스트림 유지
                    .eraseToAnyPublisher()
            }
        
        input.selectedCell
            .sink { [weak self] section, index in
                guard let self else { return }
                
                self.selectCellHandler(section: section, index: index)
            }
            .store(in: &cancellables)
        
        return Output(
            searchStudentInfoResult: searchResult.eraseToAnyPublisher(),
            navigationEvent: navigationEventSubject.eraseToAnyPublisher(),
            searchStudentInfoError: searchStudentInfoError
        )
    }
}

// MARK: - Private API Extension

private extension MypageViewModel {
    func searchMyInfoPublisher() -> AnyPublisher<UserInfoModel, MypageError> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let result = try await self.searchStudentInfoUseCase.execute()
                    promise(.success(result))
                } catch {
                    promise(.failure(.studentInfoFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods Extension

private extension MypageViewModel {
    func selectCellHandler(section: MyPageType, index: Int) {
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
