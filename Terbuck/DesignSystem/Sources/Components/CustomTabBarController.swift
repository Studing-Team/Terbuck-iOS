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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

// MARK: - Private Extensions

private extension CustomTabBarController {
    func setupStyle() {
        
    }
    
    func setupHierarchy() {
        view.addSubview(customTabBarView)
    }
    
    func setupLayout() {
        customTabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}
