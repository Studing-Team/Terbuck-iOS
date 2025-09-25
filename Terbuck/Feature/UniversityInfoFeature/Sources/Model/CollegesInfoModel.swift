//
//  CollegesInfoModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import Foundation

public struct CollegesInfoModel: Identifiable, Decodable {
    public var id: Int
    public let collegesName: String

    init(id: Int, collegesName: String) {
        self.id = id
        self.collegesName = collegesName
    }
}
