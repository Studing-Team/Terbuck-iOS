//
//  TerbuckTextFieldView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

public enum TerbuckTextFieldType {
    case name
    case studentID

    var placeholder: String {
        switch self {
        case .name: return "이름을 적어주세요"
        case .studentID: return "학번을 적어주세요"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name: return .default
        case .studentID: return .numberPad
        }
    }
}

public final class TerbuckTextFieldView: UITextField {

    private let padding = UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15)

    public init(type: TerbuckTextFieldType) {
        super.init(frame: .zero)
        configure(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(type: TerbuckTextFieldType) {
        backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
        font =  DesignSystem.Font.uiFont(.textRegular14)
        textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        tintColor = DesignSystem.Color.uiColor(.terbuckBlack10)
        placeholder = type.placeholder
        borderStyle = .none
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupEditingChanged() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    @objc private func editingChanged() {
        if let text = self.text, !text.isEmpty {
            self.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        } else {
            self.textColor = DesignSystem.Color.uiColor(.terbuckBlack10)
        }
    }

    // 텍스트 패딩 적용
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
