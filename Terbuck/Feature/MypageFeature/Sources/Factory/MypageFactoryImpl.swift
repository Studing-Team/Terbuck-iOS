//
//  MypageFactoryImpl.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit
import MypageInterface

public protocol MypageFactory {
    func makeMypageViewController(coordinator: MypageCoordinator) -> UIViewController
}

public final class MypageFactoryImpl: MypageFactory {
    
    private let searchStudentInfoUseCaseFactory: any SearchStudentInfoUseCaseFactory
    private let deleteMemberUseCaseFactory: any DeleteMemberUseCaseFactory

    public init(
        searchStudentInfoUseCaseFactory: any SearchStudentInfoUseCaseFactory,
        deleteMemberUseCaseFactory: any DeleteMemberUseCaseFactory
    ) {
        self.searchStudentInfoUseCaseFactory = searchStudentInfoUseCaseFactory
        self.deleteMemberUseCaseFactory = deleteMemberUseCaseFactory
    }

    public func makeMypageViewController(coordinator: MypageCoordinator) -> UIViewController {
        let viewModel = MypageViewModel(
            searchStudentInfoUseCase: searchStudentInfoUseCaseFactory.makeSearchStudentInfoUseCase(),
            deleteMemberUseCase: deleteMemberUseCaseFactory.makeDeleteMemberUseCase()
        )
        
        return MypageViewController(
            mypageViewModel: viewModel,
            coordinator: coordinator
        )
    }
}
