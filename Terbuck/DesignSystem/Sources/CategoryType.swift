//
//  CategoryType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/16/25.
//

import UIKit

public enum CategoryType: CaseIterable {
    case all
    case restaurant
    case cafe
    case bar
    case hospital
    case gym
    case culture
    case study

    public var title: String {
        switch self {
        case .all: return "전체"
        case .bar: return "주점"
        case .cafe: return "카페"
        case .culture: return "문화"
        case .gym: return "운동"
        case .hospital: return "병원"
        case .restaurant: return "음식"
        case .study: return "스터디"
        }
    }

    public var icon: UIImage? {
        switch self {
        case .bar: return .barIcon
        case .cafe: return .cafeIcon
        case .culture: return .cultureIcon
        case .gym: return .gymIcon
        case .hospital: return .hospitalIcon
        case .restaurant: return .restaurantIcon
        case .study: return .studyIcon
        default: return nil
        }
    }
    
    public var colorIcon: UIImage? {
        switch self {
        case .bar: return .barColorIcon
        case .cafe: return .cafeColorIcon
        case .culture: return .cultureColorIcon
        case .gym: return .gymColorIcon
        case .hospital: return .hospitalColorIcon
        case .restaurant: return .restaurantColorIcon
        case .study: return .studyColorIcon
        default: return nil
        }
    }

    public var selectIcon: UIImage? {
        switch self {
        case .bar: return .selectBarIcon
        case .cafe: return .selectCafeIcon
        case .culture: return .selectCultureIcon
        case .gym: return .selectGymIcon
        case .hospital: return .selectHospitalIcon
        case .restaurant: return .selectRestaurantIcon
        case .study: return .selectStudyIcon
        default: return nil
        }
    }

    public static func from(_ category: String) -> CategoryType {
        switch category {
        case "전체": return .all
        case "주점": return .bar
        case "카페": return .cafe
        case "문화": return .culture
        case "운동": return .gym
        case "병원": return .hospital
        case "음식": return .restaurant
        case "스터디": return .study
        default: return .all
        }
    }
}
