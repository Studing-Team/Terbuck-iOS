//
//  TerbuckFont.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/12/25.
//

import UIKit
import SwiftUI

import Resource

extension DesignSystem {
    public enum Font {
        public enum Name {
            case logoBold28
            case logoBold25
            case headBold30
            case titleBold26
            case titleBold24
            case titleBold20
            case titleSemi26
            case titleSemi20
            case textSemi18
            case textMedium18
            case textSemi16
            case textRegular20
            case textRegular16
            case textSemi14
            case textRegular14
            case captionMedium12
            case captionSemi11
            case captionRegular11
            
            var info: UIFont {
                switch self {
                case .logoBold25:
                    return UIFont(font: ResourceFontFamily.GmarketSansTTF.bold, size: 28)!
                    
                case .logoBold28:
                    return UIFont(font: ResourceFontFamily.GmarketSansTTF.bold, size: 28)!
                    
                case .headBold30:
                    return UIFont(font: ResourceFontFamily.Pretendard.bold, size: 30)!
                    
                case .titleBold26:
                    return UIFont(font: ResourceFontFamily.Pretendard.bold, size: 26)!
                    
                case .titleBold24:
                    return UIFont(font: ResourceFontFamily.Pretendard.bold, size: 24)!
                    
                case .titleBold20:
                    return UIFont(font: ResourceFontFamily.Pretendard.bold, size: 20)!
                    
                case .titleSemi26:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 26)!
                    
                case .titleSemi20:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 20)!
                    
                case .textSemi18:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 18)!
                    
                case .textMedium18:
                    return UIFont(font: ResourceFontFamily.Pretendard.medium, size: 18)!
                    
                case .textSemi16:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 16)!
                    
                case .textRegular20:
                    return UIFont(font: ResourceFontFamily.Pretendard.regular, size: 20)!
                    
                case .textRegular16:
                    return UIFont(font: ResourceFontFamily.Pretendard.regular, size: 16)!
                    
                case .textSemi14:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 14)!
                    
                case .textRegular14:
                    return UIFont(font: ResourceFontFamily.Pretendard.regular, size: 14)!
                    
                case .captionMedium12:
                    return UIFont(font: ResourceFontFamily.Pretendard.medium, size: 12)!
                    
                case .captionSemi11:
                    return UIFont(font: ResourceFontFamily.Pretendard.semiBold, size: 11)!
                    
                case .captionRegular11:
                    return UIFont(font: ResourceFontFamily.Pretendard.regular, size: 11)!
                }
            }
            
            var uiFont: UIFont {
                return info
            }
            
            var swiftFont: SwiftUI.Font {
                return SwiftUI.Font(uiFont)
            }
        }
        
        // 외부 접근용
        public static func uiFont(_ name: Name) -> UIFont {
            return name.uiFont
        }
        
        // 외부 접근용
        public static func swiftUIFont(_ name: Name) -> SwiftUI.Font {
            return name.swiftFont
        }
    }
}
