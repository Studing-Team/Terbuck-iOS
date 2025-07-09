//
//  RetryManager.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

import Shared

struct RetryPolicy {
    let maxRetryCount: Int
    let delayBeforeRetry: (_ retryCount: Int) -> TimeInterval

    static let defaultPolicy = RetryPolicy(maxRetryCount: 2) { retry in
        return pow(2.0, Double(retry))
    }
}

actor RetryManager {
    private let tokenManager = TokenManager()
    
    func executeWithRetry<T>(
        policy: RetryPolicy,
        endpointExecute: @escaping () async throws -> T
    ) async throws -> T {
        var currentRetryCount = 0
        
        while currentRetryCount < policy.maxRetryCount {
            do {
                let result = try await endpointExecute()
                
                if currentRetryCount > 0 {
                    AppLogger.log("API 호출 성공 (재시도 \(currentRetryCount)번 만에 성공)", .info, .network)
                } else {
                    AppLogger.log("API 호출 성공 (첫 시도에 성공)", .info, .network)
                }
                
                return result
            } catch let error as NetworkError {
                if currentRetryCount == policy.maxRetryCount {
                    throw NetworkError.maxRetryExceeded
                }
                
                if case .tokenExpiration = error {
                    AppLogger.log("토큰 만료 확인됨. 토큰 재발급 시도.", .info, .network)
                    try await tokenManager.refreshToken()
                }
                
                currentRetryCount += 1
            }
        }
        
        throw NetworkError.maxRetryExceeded
    }
}
