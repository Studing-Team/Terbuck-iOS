//
//  TokenManager.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

import CoreKeyChain

public actor TokenManager {
    private let keychain = KeychainManager.shared
    
    private var isRefreshing = false
    
    var accessToken: String? {
        get {
            keychain.load(key: .accessToken)
        }
    }

    var refreshToken: String? {
        get {
            keychain.load(key: .accessToken)
        }
    }
    
    func updateTokens(accessToken: String, refreshToken: String) {
        keychain.save(key: .accessToken, value: accessToken)
        keychain.save(key: .refreshToken, value: refreshToken)
    }

    func clearAllTokens() {
        keychain.clearTokens()
    }
    
    /// ✅ 리프레시 토큰으로 새로운 토큰 발급 시도
    func refreshToken() async throws {
        do {
            let result: ReissueRefreshTokenResponseDTO = try await APIClient().request(AuthAPIEndpoint.postReissue)
            
            updateTokens(accessToken: result.accessToken, refreshToken: result.refreshToken)
            
        } catch let error as NetworkError {
            throw NetworkError.tokenRefreshFailed(error)
        }
    }
}
