//
//  NotificationRepositoryImpl.swift
//  Data
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import CoreNetwork
import DomainInterface

public struct NotificationRepositoryImpl: NotificationRepository {
    
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    public func postNotificationToken(token: String) async throws {
        let requestDTO = NotificationTokenRequestDTO(deviceToken: token)
        let _: EmptyResponseDTO = try await networkManager.request(AuthAPIEndpoint.postNotificationToken(requestDTO))
    }
}