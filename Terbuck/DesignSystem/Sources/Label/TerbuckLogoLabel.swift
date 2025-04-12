//
//  TerbuckLogoLabel.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit

public final class TerbuckLogoLabel: UILabel {
    
    public enum LogoType {
        case max
        case medium
    }
    
    public init(type: LogoType) {
        super.init(frame: .zero)
        setupLabel(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension TerbuckLogoLabel {
    func setupLabel(type: LogoType) {
        let font: UIFont = type == .medium ? .logoBold25 : .logoBold28
        let fullText = "터벅."
        let attributedText = NSMutableAttributedString(string: fullText)

        // 공통 폰트
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedText.addAttribute(.font, value: font, range: fullRange)
        
        // 색상 적용
        let greenRange = (fullText as NSString).range(of: "터벅")
        attributedText.addAttribute(.foregroundColor, value: UIColor.terbuckGreen50, range: greenRange)
        
        let grayRange = (fullText as NSString).range(of: ".")
        attributedText.addAttribute(.foregroundColor, value: UIColor.terbuckDarkGray50, range: grayRange)

        self.attributedText = attributedText
    }
}
