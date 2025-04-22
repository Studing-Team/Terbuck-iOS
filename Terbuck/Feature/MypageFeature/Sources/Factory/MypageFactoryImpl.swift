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

    public init() {}

    public func makeMypageViewController(coordinator: MypageCoordinator) -> UIViewController {
        let viewModel = MypageViewModel()
        
        return MypageViewController(
            mypageViewModel: viewModel,
            coordinator: coordinator
        )
    }
}
