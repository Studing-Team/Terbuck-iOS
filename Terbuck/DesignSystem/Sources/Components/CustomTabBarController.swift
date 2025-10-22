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
    private let hapticGenerator = UIImpactFeedbackGenerator(style:  .soft)
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        tabBar.isHidden = true

        view.addSubview(customTabBarView)
        view.clipsToBounds = true // transform으로 이동한 뷰가 부모 bounds 밖으로 나가면 숨김
        
        customTabBarView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateSafeAreaInsetsForAllViewControllers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.isHidden = true
    }
    
    // MARK: - Methods
    
    public func hideTabBar() {
        self.customTabBarView.isHidden = true
        self.view.setNeedsLayout()
    }
    
    public func showTabBar() {
        self.customTabBarView.isHidden = false
        self.view.setNeedsLayout()
    }
}

// MARK: - Private Extensions

private extension CustomTabBarController {
    func setupStyle() {
        customTabBarView.onButtonTapped = { [weak self] index in
            guard let self = self else { return }

            // 1. 탭 인덱스 변경
            self.selectedIndex = index
            
            // 2. 탭바 UI 업데이트
            self.customTabBarView.updateSelectedIndex(to: index)
            
            // 3. 햅틱 피드백
            self.hapticGenerator.impactOccurred()
            
            // 4. 안전 영역 업데이트
            self.updateSafeAreaInsetsForAllViewControllers()
        }
    }
    
    /// 모든 자식 뷰컨트롤러의 Safe Area Inset을 업데이트합니다.
    func updateSafeAreaInsetsForAllViewControllers() {
        let isTabBarHidden = customTabBarView.isHidden
        
        self.viewControllers?.forEach { viewController in
            // 탭바가 숨겨져 있다면, 모든 VC의 inset을 0으로 설정
            if isTabBarHidden {
                viewController.additionalSafeAreaInsets.bottom = 0
            } else {
                // 탭바가 보일 때만 기존 로직을 실행
                let overlapHeight = customTabBarView.frame.height - view.safeAreaInsets.bottom
                viewController.additionalSafeAreaInsets.bottom = overlapHeight
            }
        }
    }
}
