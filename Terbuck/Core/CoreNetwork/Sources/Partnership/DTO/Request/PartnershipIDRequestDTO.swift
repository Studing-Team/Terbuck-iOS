//
//  PartnershipIDRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct PartnershipIDRequestDTO: QueryParameterConvertible {
    let partnership_id: Int
    
    public init(partnership_id: Int) {
        self.partnership_id = partnership_id
    }
}
