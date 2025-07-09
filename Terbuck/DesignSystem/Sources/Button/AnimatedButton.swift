//
//  AnimatedButton.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit
import Shared

public class AnimatedButton: UIButton {
    
    // 원래 색상 저장용
    var originalColor: UIColor?

    var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupAnimation() {
        self.addTarget(self, action: #selector(animateTouchDown), for: .touchDown)
        
        self.addTarget(self, action: #selector(animateTouchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    
    @objc private func animateTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.95)
            self.configuration?.baseBackgroundColor = self.originalColor?.darken(by: 0.15)
        }
    }

    @objc private func animateTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            if let color = self.originalColor {
                self.configuration?.baseBackgroundColor = color
            }
        } completion: { _ in
            self.buttonAction?()
        }
    }
}
