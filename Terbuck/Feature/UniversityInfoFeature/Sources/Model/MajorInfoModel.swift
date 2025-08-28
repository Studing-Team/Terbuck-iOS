//
//  MajorInfoModel.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import Foundation

public struct MajorInfoModel: Identifiable, Decodable {
    public var id = UUID()
    
    let majorName: String
    
    public init(majorName: String) {
        self.majorName = majorName
    }
}
