//
//  PartnerCategoryType.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation

public enum PartnerCategoryType {
    case studentAssociation
    case unknown
    
    var title : String {
        switch self {
        case .studentAssociation:
            return "총학생회"
        case .unknown:
            return "알수없음"
        }
    }
    
    static func from(_ category: String) -> PartnerCategoryType {
        switch category {
        case "총학생회":
            return .studentAssociation
        default:
            return .unknown
        }
    }
}
