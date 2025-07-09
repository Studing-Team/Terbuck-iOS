//
//  SearchStoreMapResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation

public struct SearchStoreMapResponseDTO: Decodable {
    public let list: [SearchStoreMapListData]
}

public struct SearchStoreMapListData: Decodable {
    public let shopId: Int
    public let category: String
    public let name: String
    public let thumbnailImage: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let benefitCount: Int
}
