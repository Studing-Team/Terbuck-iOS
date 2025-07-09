//
//  NotificationTokenRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/26/25.
//

import Foundation

public struct NotificationTokenRequestDTO: Encodable {
    let deviceToken: String
    
    public init(deviceToken: String) {
        self.deviceToken = deviceToken
    }
}
