//
//  DetailPartnerImageModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import Foundation
import Shared

public struct DetailPartnerImageModel: Hashable {
    let DetailPartnerimageURL: String
}

extension DetailPartnerImageModel: ImageSectionDisplayable {
    public var imageURL: String {
        DetailPartnerimageURL
    }
}
