//
//  DetailStoreImageModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import Foundation
import Shared

public struct DetailStoreImageModel: Hashable {
    let DetailStoreimageURL: String
}

extension DetailStoreImageModel: ImageSectionDisplayable {
    public var imageURL: String {
        DetailStoreimageURL
    }
}
