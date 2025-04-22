//
//  MypageTabFactory.swift
//  AuthInterface
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

public protocol MypageTabFactory {
    func makeMypageCoordinator(navigationController: UINavigationController) -> MypageCoordinating
}
