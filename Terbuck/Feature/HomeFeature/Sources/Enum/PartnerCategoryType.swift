//
//  PartnerCategoryType.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation

public enum PartnerCategoryType {
    case studentAssociation
    
    var title : String {
        switch self {
        case .studentAssociation:
            return "총학생회"
        }
    }
}
