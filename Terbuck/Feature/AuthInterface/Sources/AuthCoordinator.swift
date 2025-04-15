//
//  AuthCoordinator.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/15/25.
//

import Shared

public protocol AuthCoordinator: Coordinator {
    func startLogin()
    func startTermsOfService()
    func startUniversity()
    func finishAuthFlow()
}
