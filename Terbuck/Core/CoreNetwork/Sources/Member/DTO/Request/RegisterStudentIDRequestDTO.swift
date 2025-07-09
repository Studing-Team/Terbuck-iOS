//
//  RegisterStudentIDRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct RegisterStudentIDRequestDTO: Encodable {
    let image: Data
    let name: String
    let studentNumber: String
    
    public init(image: Data, name: String, studentNumber: String) {
        self.image = image
        self.name = name
        self.studentNumber = studentNumber
    }
}
