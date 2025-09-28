//
//  UniversityInfoListResponseDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/4/25.
//

import Foundation

public struct UniversityInfoListResponseDTO: Codable {
    public let region: RegionInfoData
    public let universities: [UniversityInfoData]
    
    public init(region: RegionInfoData, universities: [UniversityInfoData]) {
        self.region = region
        self.universities = universities
    }
}

public struct RegionInfoData: Codable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct UniversityInfoData: Codable {
    public let id: Int
    public let name: String
    public let region: RegionInfoData
    public let registered: Bool
    
    public init(id: Int, name: String, region: RegionInfoData, registered: Bool) {
        self.id = id
        self.name = name
        self.region = region
        self.registered = registered
    }
}
