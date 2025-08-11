//
//  UILabel+.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/8/25.
//

import UIKit

public extension UILabel {
    func addBottomBorderWithAttributedString(underlineColor: UIColor = .black, textColor: UIColor? = nil) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: underlineColor
        ]
        
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    /// UILabel의 여러 줄 텍스트에 대한 줄 간격(line spacing)을 설정합니다.
    /// 이 함수는 레이블의 현재 text, font, textColor, textAlignment 속성을 기반으로
    /// 새로운 NSAttributedString을 생성하여 적용합니다.
    /// - Parameters:
    ///   - lineSpacing: 적용할 줄 간격 값.
    func setLineSpacing(lineSpacing: CGFloat) {
        // 1. 레이블에 텍스트가 없으면 아무 작업도 하지 않습니다.
        guard let text = self.text else { return }
        
        // 2. 줄 간격과 정렬을 위한 ParagraphStyle을 생성합니다.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = self.textAlignment
        
        // 3. NSAttributedString에 적용할 속성들을 담을 딕셔너리를 생성합니다.
        //    - paragraphStyle: 줄 간격과 정렬
        //    - font: 레이블의 현재 폰트
        //    - foregroundColor: 레이블의 현재 텍스트 색상
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: self.font as Any,
            .foregroundColor: self.textColor as Any
        ]
        
        // 4. 텍스트와 모든 속성을 사용하여 새로운 NSAttributedString을 만듭니다.
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        // 5. 최종적으로 완성된 attributedString을 레이블에 할당합니다.
        self.attributedText = attributedString
    }
}
