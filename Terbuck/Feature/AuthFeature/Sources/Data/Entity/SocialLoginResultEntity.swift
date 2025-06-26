//
//  SocialLoginResultEntity.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation
import CoreNetwork

public struct SocialLoginResultEntity {
    let showSignup: Bool
    let id: Int
    let accessToken: String
    let refreshToken: String
}

extension SocialLoginResponseDTO {
    func toEntity() -> SocialLoginResultEntity {
        return SocialLoginResultEntity(
            showSignup: redirect,
            id: id,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
