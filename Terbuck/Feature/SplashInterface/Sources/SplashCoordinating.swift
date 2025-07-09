//
//  SplashCoordinating.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/15/25.
//

import Shared

public protocol SplashCoordinating: Coordinator {
    var delegate: SplashCoordinatorDelegate? { get set }
    
    func start()
}
