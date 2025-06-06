//
//  NetworkManager.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private init() {}
    
    private let apiClient = APIClient()
    private let retryManager = RetryManager()

    public func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        do {
            return try await retryManager.executeWithRetry(policy: RetryPolicy.defaultPolicy) {
                try await self.apiClient.request(endpoint)
            }
        } catch {
            throw NetworkError.maxRetryExceeded
        }
    }
    
    public func requestImage(url: URL) async throws -> Data {
        do {
            return try await self.apiClient.requestImageData(from: url)
        } catch (let error) {
            throw error
        }
    }
}
