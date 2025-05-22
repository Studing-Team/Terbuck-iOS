//
//  TerbuckButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import UIKit

extension DesignSystem {
    public enum Button {
        public static func studentIDCardButton() -> UIButton {
            let button = StudentIDCardButton()
            return button
        }
        
        public static func naverMovementButton() -> UIButton {
           return TerbuckBottomButton(type: .moveNaver)
        }
    }
}
