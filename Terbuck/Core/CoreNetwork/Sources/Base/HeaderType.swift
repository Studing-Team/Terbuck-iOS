//
//  HeaderType.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation
import CoreKeyChain

public enum HeaderType {
    case defaultHeader
    case accessTokenHeader
    case refreshTokenHeader
    
    var headers: [String : String] {
        var headers: [String: String] = [:]
        
        switch self {
        case .accessTokenHeader:
            if let token = KeychainManager.shared.load(key: .accessToken) {
                headers["authorization"] = "Bearer \(token)"
            }
            
        case .refreshTokenHeader:
            if let token = KeychainManager.shared.load(key: .refreshToken) {
                headers["authorization"] = "Bearer \(token)"
            }
            
        case .defaultHeader:
            break
        }
        
        return headers
    }
}
