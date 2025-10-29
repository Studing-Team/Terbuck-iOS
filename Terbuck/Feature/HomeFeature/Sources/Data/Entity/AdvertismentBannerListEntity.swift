//
//  AdvertismentBannerListEntity.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 10/25/25.
//

import Foundation
import CoreNetwork

public struct AdvertismentBannerListEntity {
    let id: Int
    let imageUrl: String    // 배경 이미지 URL
    let linkUrl: String     // 클릭 시 이동할 URL
    
    public init(id: Int, imageUrl: String, linkUrl: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.linkUrl = linkUrl
    }
}

extension AdvertisementBannerListResponseDTO {
    func toEntity() -> AdvertismentBannerListEntity {
        return AdvertismentBannerListEntity(
            id: self.id,
            imageUrl: self.imageURL,
            linkUrl: self.link
        )
    }
}
