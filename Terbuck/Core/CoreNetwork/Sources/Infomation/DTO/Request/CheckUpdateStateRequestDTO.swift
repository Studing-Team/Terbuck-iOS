//
//  CheckUpdateStateRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/25/25.
//

import Foundation

public struct CheckUpdateStateRequestDTO: QueryParameterConvertible {
    public let os: String
    public let currentVersion: String
    
    public init(os: String = "IOS", version: String) {
        self.os = os
        self.currentVersion = version
    }
}
