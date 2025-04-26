//
//  GuideOverlayView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

public final class GuideOverlayView: UIView {
    
    // MARK: - Init
    
    init(holeRect: CGRect, cornerRadius: CGFloat) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .terbuckStudentBackground
        isUserInteractionEnabled = false
        
        let path = UIBezierPath(rect: bounds)
        let circlePath = UIBezierPath(roundedRect: holeRect, cornerRadius: cornerRadius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        
        layer.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
