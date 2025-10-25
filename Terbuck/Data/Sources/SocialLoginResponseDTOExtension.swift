//
//  SocialLoginResponseDTOExtension.swift
//  Data
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import CoreNetwork
import DomainInterface

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
