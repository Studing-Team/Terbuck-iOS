//
//  DetailStoreHeaderModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import Foundation
import Shared

public struct DetailStoreHeaderModel: Identifiable, Hashable {
    public var id: String {
        return "\(storeName) - \(storeAddress)"
    }
    
    var storeName: String
    var storeAddress: String
}

extension DetailStoreHeaderModel: TitleSectionDisplayable {
    public var titleText: String {
        storeName
    }

    public var subtitleText: String {
        storeAddress
    }
}
