//
//  PartnerStoreType.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/28/25.
//

import Foundation

public enum PartnerStoreType: CaseIterable {
    case hospital
    case culture
    case education
    
    var title: String {
        switch self {
        case .hospital:
            return "병원"
        case .culture:
            return "문화"
        case .education:
            return "교육"
        }
    }
}
