//
//  StoreFilterType.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/23/25.
//

import Foundation

public enum StoreFilterType: CaseIterable {
    case restaurent
    case convenient
    case partnership
    
    var title: String {
        switch self {
        case .convenient:
            return "이용하기"
        case .partnership:
            return "파트너십"
        case .restaurent:
            return "먹고가기"
        }
    }
}
