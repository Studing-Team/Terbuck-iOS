//
//  UniversityInfoModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 9/4/25.
//

import Foundation

public struct UniversityInfoModel: Identifiable {
    public var id: Int
    public let title: String
    public let items: [String]
}
