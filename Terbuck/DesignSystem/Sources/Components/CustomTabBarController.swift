//
//  CustomTabBarController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/24/25.
//

import UIKit

import SnapKit
import Then

public final class CustomTabBarController: UITabBarController {
    
    public let customTabBarView = CustomTabBar()
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setupStyle()
    }
}

// MARK: - Private Extensions

private extension CustomTabBarController {
    func setupStyle() {
        setValue(customTabBarView, forKey: "tabBar")
    }
}

// UITabBarControllerDelegate 구현
extension CustomTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.customTabBarView.updateSelectedIndex(to: selectedIndex)
        
        // 햅틱 피드백
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
