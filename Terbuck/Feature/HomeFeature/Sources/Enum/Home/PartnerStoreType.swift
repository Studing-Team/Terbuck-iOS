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
    case unknown
    
    var title: String {
        switch self {
        case .hospital:
            return "병원"
        case .culture:
            return "문화"
        case .education:
            return "교육"
        case .unknown:
            return "알수없음"
        }
    }
    
    static func from(_ institution: String) -> PartnerStoreType {
        switch institution {
        case "병원":
            return .hospital
        case "문화":
            return .culture
        case "교육":
            return .education
        default:
            return .unknown
        }
    }
}
