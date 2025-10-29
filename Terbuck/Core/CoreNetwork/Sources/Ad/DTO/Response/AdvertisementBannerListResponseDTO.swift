//
//  AdvertisementBannerListResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 10/25/25.
//

import Foundation

public struct AdvertisementBannerListResponseDTO: Decodable {
    public let id: Int
    public let title: String
    public let imageURL: String
    public let link: String
    
    public init(id: Int, title: String, imageURL: String, link: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.link = link
    }
}
