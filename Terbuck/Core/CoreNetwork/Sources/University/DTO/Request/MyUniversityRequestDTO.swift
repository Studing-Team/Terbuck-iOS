//
//  MyUniversityRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public struct MyUniversityRequestDTO: QueryParameterConvertible {
    public let universityName: String
    
    public init(universityName: String) {
        self.universityName = universityName
    }
}
