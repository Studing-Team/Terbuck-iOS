//
//  RetryManager.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

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
                if currentRetryCount > 0 {
                    print("🚀 토큰 유효기간 지남, Retry 시작")
                }
                
                return try await endpointExecute()
            } catch let error as NetworkError {
                if currentRetryCount == policy.maxRetryCount {
                    throw NetworkError.maxRetryExceeded
                }
                
                if case .tokenExpiration = error {
                    try await tokenManager.refreshToken()
                }
                
                currentRetryCount += 1
            }
        }
        
        throw NetworkError.maxRetryExceeded
    }
}
