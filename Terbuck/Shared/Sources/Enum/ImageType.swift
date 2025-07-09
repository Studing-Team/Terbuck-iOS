//
//  ImageType.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/9/25.
//

import Foundation
import UIKit

public enum ImageType {
    case partnership
    case storelist
    case detailStore
    case largeDetailStore
    
    var imagesSize: CGSize {
        switch self {
        case .partnership:
            return CGSize(width: UIScreen.main.bounds.width * 335 / 375 , height: UIScreen.main.bounds.height * 335 / 812)
            
        case .storelist:
            return CGSize(width: UIScreen.main.bounds.width * 88 / 375 , height: UIScreen.main.bounds.height * 88 / 812)
            
        case .detailStore:
            return CGSize(width: UIScreen.main.bounds.width * 185 / 375 , height: UIScreen.main.bounds.height * 185 / 812)
            
        case .largeDetailStore:
            return CGSize(width: UIScreen.main.bounds.width * 375 / 375 , height: UIScreen.main.bounds.height * 375 / 812)
        }
    }
}
