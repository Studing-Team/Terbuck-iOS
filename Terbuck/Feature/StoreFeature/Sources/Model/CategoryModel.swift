//
//  CategoryModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/19/25.
//

import UIKit
import DesignSystem

public struct CategoryModel: Identifiable, Hashable {
    public var id: String {
        return "\(type.title)"
    }
    let type: CategoryType
    var isSelected: Bool
}
