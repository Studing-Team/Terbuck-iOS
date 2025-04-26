//
//  TerbuckUnderLineLabel.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

final class TerbuckUnderlineLabel: UILabel {
    
    public var underlineColor: UIColor = .black {
        didSet { updateAttributedText() }
    }
    
    public override var text: String? {
        didSet { updateAttributedText() }
    }
    
    public override var font: UIFont! {
        didSet { updateAttributedText() }
    }
    
    public override var textColor: UIColor! {
        didSet { updateAttributedText() }
    }
    
    private func updateAttributedText() {
        guard let text = text else {
            attributedText = nil
            return
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 0

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: textColor ?? .black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: underlineColor,
            .paragraphStyle: paragraph
        ]
        
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("TerbuckUnderlineLabel") {
    TerbuckUnderlineLabel()
        .showPreview()
}
#endif
