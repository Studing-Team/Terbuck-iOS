//
//  SocialLoginResultEntity.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public struct SocialLoginResultEntity {
    public let showSignup: Bool
    public let id: Int
    public let accessToken: String
    public let refreshToken: String
    
    public init(showSignup: Bool, id: Int, accessToken: String, refreshToken: String) {
        self.showSignup = showSignup
        self.id = id
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}