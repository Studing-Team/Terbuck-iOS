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
    
    func showConfirmAlert(
        mainTitle: String,
        subTitle: String? = nil,
        centerButton: TerbuckBottomButton,
        centerButtonHandler: (() -> Void)? = nil
    ) {
        let customAlertViewController = CustomAlertViewController(
            mainTitle: mainTitle,
            subTitle: subTitle,
            centerButton: centerButton,
            centerButtonHandler: centerButtonHandler
        )
        
        customAlertViewController.modalPresentationStyle = .overFullScreen
        present(customAlertViewController, animated: false)
    }
    
    func showStoreBenefitAlert(storeName: String, address: String, category: CategoryType, benefitData: [StoreBenefitsModel]) {
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

public extension UIViewController {
    /// 키보드 이벤트 처리를 위한 설정을 수행하는 메서드
    /// - Parameter spacing: 키보드와 텍스트필드 사이의 여백 (기본값: 40pt)
    func setupKeyboardHandling(with spacing: CGFloat = 40) {
        // 키보드가 나타날 때의 알림 observer 등록
        NotificationCenter.default.addObserver(
            self,                                        // 현재 ViewController를 observer로 등록
            selector: #selector(handleKeyboardWillShow), // 키보드 표시 시 호출될 메서드
            name: UIResponder.keyboardWillShowNotification, // 키보드 표시 알림
            object: nil                                  // 특정 객체의 알림만 받지 않고 모든 알림 수신
        )
        
        // 키보드가 사라질 때의 알림 observer 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // 화면 터치 시 키보드를 숨기기 위한 제스처 추가
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        view.addGestureRecognizer(tapGesture)
    }
    
    /// 키보드가 나타날 때 호출되는 메서드
    /// - Parameter notification: 키보드 관련 정보를 포함한 알림 객체
    @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
        // notification에서 키보드 크기와 애니메이션 시간 추출
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // 키보드의 실제 높이 계산
        let keyboardHeight = keyboardFrame.cgRectValue.height
        print("⌨️ Keyboard height: \(keyboardHeight)")
        
        // 현재 포커스된 텍스트필드 찾기
        if let activeField = view.firstResponder as? UITextField {
            // 텍스트필드의 좌표를 현재 view의 좌표계로 변환
            let fieldFrame = activeField.convert(activeField.bounds, to: view)
            print("📱 Field frame: \(fieldFrame)")
            
            // 텍스트필드 하단부터 화면 하단까지의 거리 계산
            let distanceToBottom = view.frame.height - (fieldFrame.origin.y + fieldFrame.height)
            print("↕️ Distance to bottom: \(distanceToBottom)")
            
            // 키보드에 의해 가려지는 공간 계산 (여유 공간 40pt 추가)
            let collapseSpace = keyboardHeight - distanceToBottom + 80
            print("📏 Collapse space: \(collapseSpace)")
            
            // 텍스트필드가 키보드에 가려질 경우에만 화면을 위로 이동
            if collapseSpace > 0 {
                // 설정된 시간동안 부드럽게 화면 이동 애니메이션 실행
                UIView.animate(withDuration: duration) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -collapseSpace) // 화면을 위로 이동
                    print("⬆️ Moving view up by: \(collapseSpace)")
                }
            }
        }
    }
    
    /// 키보드가 사라질 때 호출되는 메서드
    /// - Parameter notification: 키보드 관련 정보를 포함한 알림 객체
    @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
        // notification에서 애니메이션 시간 추출
        guard let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        print("⬇️ Moving view back to original position")
        // 설정된 시간동안 부드럽게 화면을 원래 위치로 되돌리는 애니메이션 실행
        UIView.animate(withDuration: duration) {
            self.view.transform = .identity  // 화면을 원래 위치로 복원
        }
    }
}

public extension UIViewController {
    /// CustomTabBarController의 탭바를 숨깁니다.
    func hideCustomTabBar() {
        guard let customTabBarController = self.tabBarController as? CustomTabBarController else { return }
        customTabBarController.hideTabBar()
    }
    
    /// CustomTabBarController의 탭바를 보여줍니다
    func showCustomTabBar() {
        guard let customTabBarController = self.tabBarController as? CustomTabBarController else { return }
        customTabBarController.showTabBar()
    }
}

public extension UIView {
    // firstResponder를 쉽게 찾기 위한 UIView extension
    var firstResponder: UIView? {
        if isFirstResponder {
            return self
        }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}
