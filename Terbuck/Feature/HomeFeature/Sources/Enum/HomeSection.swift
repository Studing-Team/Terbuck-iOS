//
//  HomeSection.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/30/25.
//

import Foundation

public enum HomeSection: CaseIterable, Hashable {
    case restaurant
    case convenient
    case newBenefit // 파트너십 필터의 새로운 혜택 섹션
    case general // 파트너십 필터의 일반 혜택 섹션
}
