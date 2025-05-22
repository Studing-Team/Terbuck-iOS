//
//  PreviewImageModel.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/14/25.
//

import Foundation

public struct PreviewImageModel {
    public let imageIndex: Int
    public let title: String
    public let images: [Data]
    
    public init(imageIndex: Int, title: String, images: [Data]) {
        self.imageIndex = imageIndex
        self.title = title
        self.images = images
    }
}
