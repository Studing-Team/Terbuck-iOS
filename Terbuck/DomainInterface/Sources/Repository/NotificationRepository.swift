//
//  NotificationRepository.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol NotificationRepository {
    func postNotificationToken(token: String) async throws
}