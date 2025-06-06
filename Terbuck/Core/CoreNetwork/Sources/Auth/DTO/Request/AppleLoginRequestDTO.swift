//
//  AppleLoginRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct AppleLoginRequestDTO: Encodable {
    let code: String
    let name: String?
    
    public init(code: String, name: String?) {
        self.code = code
        self.name = name
    }
}
