//
//  RegisterStudentIDRequestDTO.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct RegisterStudentIDRequestDTO: Encodable {
    let idCardImage: Data
    let name: String
    let studentNumber: String
    
    public init(idCardImage: Data, name: String, studentNumber: String) {
        self.idCardImage = idCardImage
        self.name = name
        self.studentNumber = studentNumber
    }
}
