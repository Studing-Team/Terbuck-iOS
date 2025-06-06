//
//  SizeLiterals.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/28/25.
//

import UIKit

public struct SizeLiterals {
    public struct Screen {
        public static let screenWidth: CGFloat = UIScreen.main.bounds.width
        public static let screenHeight: CGFloat = UIScreen.main.bounds.height
        public static let deviceRatio: CGFloat = screenWidth / screenHeight
    }
}
