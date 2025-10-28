//
//  PartnershipDisclosureRequestResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public struct PartnershipDisclosureRequestResponseDTO: Codable {
    public let openRequestId: Int
    public let universityName: String
    
    public init(openRequestId: Int, universityName: String) {
        self.openRequestId = openRequestId
        self.universityName = universityName
    }
}
