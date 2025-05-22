//
//  UIView+.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/8/25.
//

import UIKit

public extension UIView {
    
    /// 한 번에 여러 개의 UIView 또는 UIView의 하위 클래스 객체들을 상위 UIView에 추가
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

public extension UIView {
    // MARK: - 그라데이션
    
    enum GradientDirection {
        case topRightToBottomLeft
        case leftToRight
        case topToBottom
        
        var startPoint: CGPoint {
            switch self {
            case .topRightToBottomLeft: return CGPoint(x: 0.7, y: 0)
            case .leftToRight: return CGPoint(x: 0, y: 0.5)
            case .topToBottom: return CGPoint(x: 0.5, y: 0)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .topRightToBottomLeft: return CGPoint(x: 0, y: 1)
            case .leftToRight: return CGPoint(x: 1, y: 0.5)
            case .topToBottom: return CGPoint(x: 0.5, y: 1)
            }
        }
    }
    
    func applyGradient(colors: [UIColor], direction: GradientDirection, locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        gradientLayer.locations = locations
        
        // 기존의 그라데이션 레이어가 있다면 제거
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - 기기 대응

public extension UIView {
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceWidth() / 375)
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
        return convert * (getDeviceHeight() / 812)
    }
}

// MARK: - View 미리보기

#if canImport(SwiftUI) && DEBUG
import SwiftUI

public extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) { }
    }

    func showPreview() -> some View {
        Preview(view: self)
    }
}
#endif
