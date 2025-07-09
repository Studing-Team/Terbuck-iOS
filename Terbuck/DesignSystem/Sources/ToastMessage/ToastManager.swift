//
//  ToastManager.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

import SnapKit
import Then

public final class ToastManager {
    
    public static let shared = ToastManager()
    private init() {}
    
    private var isPresenting = false
    
    public func showToast(from viewController: UIViewController, type: ToastType, action: (() -> Void)? = nil) {
        guard !isPresenting else { return }

        isPresenting = true

        let toastView = ToastMessageView(type: type)
        
        toastView.setAction {
            action?()
        }
        
        viewController.view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(viewController.view.safeAreaLayoutGuide).inset(type.padding)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        toastView.alpha = 0
        toastView.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.3) {
            toastView.alpha = 1
            toastView.transform = .identity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 0
                toastView.transform = CGAffineTransform(translationX: 0, y: 20)
            }, completion: { _ in
                toastView.removeFromSuperview()
                self.isPresenting = false
            })
        }
    }
}
