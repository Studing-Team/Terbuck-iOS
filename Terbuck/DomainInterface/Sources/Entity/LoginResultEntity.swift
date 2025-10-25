//
//  LoginResultEntity.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public struct LoginResultEntity {
    public let showSignup: Bool
    public let userId: Int
    public let accessToken: String
    public let refreshToken: String
    
    public init(showSignup: Bool, userId: Int, accessToken: String, refreshToken: String) {
        self.showSignup = showSignup
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
