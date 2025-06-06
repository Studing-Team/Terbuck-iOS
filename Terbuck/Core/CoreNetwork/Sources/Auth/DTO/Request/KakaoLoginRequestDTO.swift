//
//  KakaoLoginRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct KakaoLoginRequestDTO: Encodable {
    let token: String

    public init(token: String) {
        self.token = token
    }
}
