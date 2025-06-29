//
//  StoreBenefitsModel.swift
//  Shared
//
//  Created by ParkJunHyuk on 6/28/25.
//

import Foundation

public struct StoreBenefitsModel: Hashable {
    public let title: String
    public let details: [String]
    
    public init(title: String, details: [String]) {
        self.title = title
        self.details = details
    }
}
