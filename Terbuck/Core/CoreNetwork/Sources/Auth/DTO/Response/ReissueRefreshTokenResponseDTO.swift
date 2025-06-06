//
//  ReissueRefreshTokenResponseDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct ReissueRefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
