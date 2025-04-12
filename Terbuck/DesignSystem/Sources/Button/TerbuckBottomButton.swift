//
//  TerbuckBottomButton.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import SnapKit

public final class TerbuckBottomButton: AnimatedButton {
    
    // MARK: - Enum Properties
    
    public enum TerbuckButtonType {
        case next
        case enter
        case register
        
        var title: String {
            switch self {
            case .next: return "다음"
            case .enter: return "터벅 들어가기"
            case .register: return "등록하기"
            }
        }
    }
    
    // MARK: - Init

    public init(type: TerbuckButtonType, isEnabled: Bool = true) {
        super.init(frame: .zero)
        setupButton(title: type.title, isEnabled: isEnabled)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
        updateColor()
    }
}

// MARK: - Private Extensions

private extension TerbuckBottomButton {
    func setupButton(title: String, isEnabled: Bool) {
        var config = UIButton.Configuration.filled()
        // 텍스트 설정
        let titleString = AttributedString(title, attributes: .init(
            [.font: UIFont.textSemi18]
        ))
        config.attributedTitle = titleString
        
        // ✅ 상태 상관없이 항상 같은 색 유지
        config.background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
            return isEnabled ? .terbuckGreen50 : .terbuckGreen10
        }
        
        config.baseForegroundColor = .white
        configuration = config
        
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        self.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
    
    func updateColor() {
        guard var config = configuration else { return }
        config.baseBackgroundColor = isEnabled ? .terbuckGreen50 : .terbuckGreen10
        configuration = config
    }
}
