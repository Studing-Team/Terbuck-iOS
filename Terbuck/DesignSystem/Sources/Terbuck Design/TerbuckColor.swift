//
//  TerbuckColor.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit
import SwiftUI

import Resource

public enum DesignSystem {
    public enum Color {
        public enum Name: String, CaseIterable {
            case terbuckBlack5
            case terbuckBlack10
            case terbuckBlack30
            case terbuckBlack40
            case terbuckBlack50
            case terbuckDarkGray10
            case terbuckDarkGray50
            case terbuckGreen10
            case terbuckGreen50
            case terbuckWhite
            case terbuckWhite3
            case terbuckWhite5
            case terbuckAlertBackground
            case terbuckToastBackground
            case terbuckStudentBackground
            case terbuckPartnerBlack
            case terbuckBottomGradient
            
            var info: UIColor {
                switch self {
                case .terbuckBlack5:
                    return UIColor(asset: ResourceAsset.Color.terbuckBlack5)!
                case .terbuckBlack10:
                    return UIColor(asset: ResourceAsset.Color.terbuckBlack10)!
                case .terbuckBlack30:
                    return UIColor(asset: ResourceAsset.Color.terbuckBlack30)!
                case .terbuckBlack40:
                    return UIColor(asset: ResourceAsset.Color.terbuckBlack40)!
                case .terbuckBlack50:
                    return UIColor(asset: ResourceAsset.Color.terbuckBlack50)!
                case .terbuckDarkGray10:
                    return UIColor(asset: ResourceAsset.Color.terbuckDarkGray10)!
                case .terbuckDarkGray50:
                    return UIColor(asset: ResourceAsset.Color.terbuckDarkGray50)!
                case .terbuckGreen10:
                    return UIColor(asset: ResourceAsset.Color.terbuckGreen10)!
                case .terbuckGreen50:
                    return UIColor(asset: ResourceAsset.Color.terbuckGreen50)!
                case .terbuckWhite:
                    return UIColor(asset: ResourceAsset.Color.terbuckWhite)!
                case .terbuckWhite3:
                    return UIColor(asset: ResourceAsset.Color.terbuckWhite3)!
                case .terbuckWhite5:
                    return UIColor(asset: ResourceAsset.Color.terbuckWhite5)!
                case .terbuckAlertBackground:
                    return  UIColor(asset: ResourceAsset.Color.terbuckAlertBack)!
                case .terbuckToastBackground:
                    return UIColor(asset: ResourceAsset.Color.terbuckToast)!
                case .terbuckStudentBackground:
                    return UIColor(asset: ResourceAsset.Color.terbuckAlertBack)!
                        .withAlphaComponent(0.90)
                case .terbuckPartnerBlack:
                    return UIColor(asset: ResourceAsset.Color.terbuckPartnerBlack)!
                case .terbuckBottomGradient:
                    return UIColor(asset: ResourceAsset.Color.terbuckBottomGradient)!
                }
            }
            
            public var uiColor: UIColor {
                info
            }
            
            var swiftUIColor: SwiftUI.Color {
                SwiftUI.Color(uiColor: uiColor)
            }
        }
        
        public static func uiColor(_ name: Name) -> UIColor {
            name.uiColor
        }
        
        public static func swiftUIColor(_ name: Name) -> SwiftUI.Color {
            name.swiftUIColor
        }
    }
}
