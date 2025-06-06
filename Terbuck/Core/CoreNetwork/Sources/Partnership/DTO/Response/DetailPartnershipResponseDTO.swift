//
//  DetailPartnershipResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/28/25.
//

import Foundation

public struct DetailPartnershipResponseDTO: Decodable {
    public let name: String
    public let institution: String
    public let imageList: [String]
    public let detail: String
    public let snsLink: String
}
