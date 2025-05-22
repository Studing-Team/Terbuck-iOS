//
//  DetailPartnerImageModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import Foundation
import Shared

public struct DetailPartnerImageModel: Hashable {
    let DetailPartnerimages: Data
}

extension DetailPartnerImageModel: ImageSectionDisplayable {
    public var images: Data {
        DetailPartnerimages
    }
}
