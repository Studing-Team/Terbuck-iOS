//
//  CheckUpdateStateResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/25/25.
//

import Foundation

public struct CheckUpdateStateResponseDTO: Decodable {
    public let isUpdateNeeded: Bool
    public let currentVersion: String
    public let leastRequiredVersion: String
    
    init(isUpdateNeeded: Bool, currentVersion: String, leastRequiredVersion: String) {
        self.isUpdateNeeded = isUpdateNeeded
        self.currentVersion = currentVersion
        self.leastRequiredVersion = leastRequiredVersion
    }
}
