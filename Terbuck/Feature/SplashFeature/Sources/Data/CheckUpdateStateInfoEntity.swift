//
//  CheckUpdateStateInfoEntity.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 9/26/25.
//

import Foundation
import CoreNetwork

public struct CheckUpdateStateInfoEntity: Decodable {
    public let isUpdateAvailable: Bool
}

extension CheckUpdateStateResponseDTO {
    func toEntity() -> CheckUpdateStateInfoEntity {
        return CheckUpdateStateInfoEntity(isUpdateAvailable: self.isUpdateNeeded)
    }
}
