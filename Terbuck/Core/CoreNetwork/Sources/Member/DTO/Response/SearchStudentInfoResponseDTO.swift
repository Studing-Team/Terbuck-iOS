//
//  SearchStudentInfoResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public struct SearchStudentInfoResponseDTO: Decodable {
    public let name: String
    public let university: String
    public let isRegistered: Bool
    public let studentNumber: String?
    public let imageURL: String?
}
