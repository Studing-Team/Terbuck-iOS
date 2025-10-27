//
//  BannerItemModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 10/25/25.
//

import Foundation

public struct BannerItemModel: Hashable {
    let id: Int
    public let imageUrl: String    // 배경 이미지 URL
    public let linkUrl: String     // 클릭 시 이동할 URL
    
    public init(id: Int, imageUrl: String, linkUrl: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.linkUrl = linkUrl
    }
}
