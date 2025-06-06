//
//  SocialLoginResponseDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct SocialLoginResponseDTO: Decodable {
    public let redirect: Bool
    public let accessToken: String
    public let refreshToken: String
}
