//
//  SearchStoreResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public struct StoreBenefitResponseDTO: Decodable {
    public let list: [StoreListData]
}

public struct StoreListData: Decodable {
    public let shopId: Int
    public let category: String
    public let name: String
    public let address: String
    public let benefitList: [StoreBenefitData]
    
    public init(shopId: Int, category: String, name: String, address: String, benefitList: [StoreBenefitData]) {
        self.shopId = shopId
        self.category = category
        self.name = name
        self.address = address
        self.benefitList = benefitList
    }
}

public struct StoreBenefitData: Decodable {
    public let title: String
    public let detailList: [String]
    
    public init(title: String, detailList: [String]) {
        self.title = title
        self.detailList = detailList
    }
}
