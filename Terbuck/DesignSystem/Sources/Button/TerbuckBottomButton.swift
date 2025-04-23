//
//  TerbuckBottomButton.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import SnapKit

public enum TerbuckButtonType {
    case next
    case enter
    case register
    case logout
    case cancel
    case draw
    case save
    case close
    
    var title: String {
        switch self {
        case .next: return "다음"
        case .enter: return "터벅 들어가기"
        case .register: return "등록하기"
        case .logout: return "로그아웃"
        case .cancel: return "취소"
        case .draw: return "탈퇴할게요"
        case .save: return "저장하기"
        case .close: return "닫기"
        }
    }
    
    var font: UIFont {
        switch self {
        case .cancel, .logout, .draw:
            return UIFont.textSemi16
        default:
            return UIFont.textSemi18
        }
    }
    
    var height: CGFloat {
        switch self {
        case .cancel, .logout, .draw:
            return 39
        default:
            return 52
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .cancel, .close:
            return .terbuckBlack5
        default:
            return .terbuckGreen50
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .cancel, .logout, .draw:
            return 8
        default:
            return 16
        }
    }
    
    func resolvedBackgroundColor(isEnabled: Bool) -> UIColor {
        switch self {
        case .enter:
            return isEnabled ? .terbuckGreen50 : .terbuckGreen10
        default:
            return backgroundColor
        }
    }
}

public final class TerbuckBottomButton: AnimatedButton {
    
    // MARK: - Enum Properties
    
    // MARK: - Init

    public init(type: TerbuckButtonType, isEnabled: Bool = true) {
        super.init(frame: .zero)
        setupButton(type: type, isEnabled: isEnabled)
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
    func setupButton(type: TerbuckButtonType, isEnabled: Bool) {
        var config = UIButton.Configuration.filled()
        
        let titleString = AttributedString(type.title, attributes: .init(
            [.font: type.font]
        ))
        config.attributedTitle = titleString
        
        // ✅ 상태 상관없이 항상 같은 색 유지
        config.background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
            return type.resolvedBackgroundColor(isEnabled: isEnabled)
        }
        
        config.baseForegroundColor = .white
        configuration = config
        
        self.layer.cornerRadius = type.cornerRadius
        self.clipsToBounds = true
        
        self.snp.makeConstraints {
            $0.height.equalTo(type.height)
        }
    }
    
    func updateColor() {
        guard var config = configuration else { return }
        config.baseBackgroundColor = isEnabled ? .terbuckGreen50 : .terbuckGreen10
        configuration = config
    }
}
