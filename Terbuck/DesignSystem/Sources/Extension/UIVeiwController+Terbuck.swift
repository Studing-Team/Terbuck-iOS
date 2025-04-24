//
//  UIVeiwController+Terbuck.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit
import Shared

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
    
    func showStoreBenefitAlert(storeName: String, address: String, category: CategoryType, benefitData: [String]) {
        let customStoreBenefitAlertViewController = CustomBenefitAlertViewController(
            name: storeName,
            address: address,
            category: category,
            benefitData: benefitData
        )

        customStoreBenefitAlertViewController.modalPresentationStyle = .overFullScreen
        present(customStoreBenefitAlertViewController, animated: false)
    }
}
