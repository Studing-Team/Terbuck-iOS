//
//  DetailPartnershipModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import Foundation
import Shared

public struct DetailPartnershipModel: Identifiable, Hashable {
    public var id: String {
        return "\(partnershipName) - \(partnerCategoryType)"
    }
    
    var partnershipName: String
    var partnerCategoryType: PartnerCategoryType
}

extension DetailPartnershipModel: TitleSectionDisplayable {
    public var titleText: String {
        partnershipName
    }

    public var subtitleText: String {
        partnerCategoryType.title
    }
}
