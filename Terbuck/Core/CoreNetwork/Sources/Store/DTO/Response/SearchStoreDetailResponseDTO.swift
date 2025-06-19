//
//  SearchStoreDetailResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation

public struct SearchStoreDetailResponseDTO: Decodable {
    public let name: String
    public let shopLink: String
    public let imageList: [String]
    public let address: String
    public let benefitCount: Int
    public let benefitList: [StoreBenefitData]
    public let usagesList: [SearchDetailStoreUsagesData]
    
    public init(
        name: String,
        shopLink: String,
        imageList: [String],
        address: String,
        benefitCount: Int,
        benefitList: [StoreBenefitData],
        usagesList: [SearchDetailStoreUsagesData]
    ) {
        self.name = name
        self.shopLink = shopLink
        self.imageList = imageList
        self.address = address
        self.benefitCount = benefitCount
        self.benefitList = benefitList
        self.usagesList = usagesList
    }
}

public struct SearchDetailStoreUsagesData: Decodable {
    public let introduction: String
}
