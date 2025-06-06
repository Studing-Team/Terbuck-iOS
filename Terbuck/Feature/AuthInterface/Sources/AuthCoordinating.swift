//
//  AuthCoordinating.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/15/25.
//

import Shared

public protocol AuthCoordinating: Coordinator {
    var delegate: AuthCoordinatorDelegate? { get set }
    
    func startLogin()
    func startTermsOfService()
    func startUniversity()
    func finishAuthFlow()
}
