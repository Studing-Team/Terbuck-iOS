//
//  PreviewImageDisplayable.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/14/25.
//

import Foundation

public protocol PreviewImageDisplayable: AnyObject {
    var selectImageData: PreviewImageModel? { get }
}
