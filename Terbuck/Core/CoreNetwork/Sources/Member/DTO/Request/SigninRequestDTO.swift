//
//  SigninRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct SigninRequestDTO: Encodable {
    let university: String
    let collgeId: Int
    
    public init(university: String, collgeId: Int) {
        self.university = university
        self.collgeId = collgeId
    }
}
