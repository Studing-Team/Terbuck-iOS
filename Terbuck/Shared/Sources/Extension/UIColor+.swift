//
//  UIColor+.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit

public extension UIColor {
    // 색상을 어둡게 (눌림 효과)
    func darken(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(
            red: max(red - percentage, 0),
            green: max(green - percentage, 0),
            blue: max(blue - percentage, 0),
            alpha: alpha
        )
    }
}
