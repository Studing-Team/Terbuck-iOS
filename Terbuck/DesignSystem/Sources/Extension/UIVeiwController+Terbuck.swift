//
//  UIVeiwController+Terbuck.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit

public extension UIViewController {
    func showConfirmCancelAlert(
        mainTitle: String,
        subTitle: String? = nil,
        leftButton: TerbuckBottomButton,
        rightButton: TerbuckBottomButton,
        leftButtonHandler: (() -> Void)? = nil,
        rightButtonHandler: (() -> Void)? = nil
    ) {
        let customAlertViewController = CustomAlertViewController(
            mainTitle: mainTitle,
            subTitle: subTitle,
            leftButton: leftButton,
            rightButton: rightButton,
            leftButtonHandler: leftButtonHandler,
            rightButtonHandler: rightButtonHandler
        )
        
        customAlertViewController.modalPresentationStyle = .overFullScreen
        present(customAlertViewController, animated: false)
    }
}
