//
//  SigninRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct SigninRequestDTO: Encodable {
    let university: String
//    let agreedToService: Bool
//    let agreedToEssentialInfo: Bool
//    let agreedToOptional: Bool
    
    public init(university: String) {//, agreedToService: Bool, agreedToEssentialInfo: Bool, agreedToOptional: Bool) {
        self.university = university
//        self.agreedToService = agreedToService
//        self.agreedToEssentialInfo = agreedToEssentialInfo
//        self.agreedToOptional = agreedToOptional
    }
}
