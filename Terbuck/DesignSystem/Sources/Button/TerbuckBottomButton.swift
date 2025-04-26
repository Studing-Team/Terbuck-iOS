//
//  TerbuckBottomButton.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit

import SnapKit
import Then

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
        case .enter, .register:
            return isEnabled ? .terbuckGreen50 : .terbuckGreen10
        default:
            return backgroundColor
        }
    }
}

public final class TerbuckBottomButton: AnimatedButton {
    
    // MARK: - Properties
    
    private var type: TerbuckButtonType

    // MARK: - Init
    
    public init(type: TerbuckButtonType, isEnabled: Bool = true) {
        self.type = type
        super.init(frame: .zero)
        
        self.isEnabled = isEnabled
        setupButton(type: type)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension TerbuckBottomButton {
    func setupButton(type: TerbuckButtonType) {
        var config = UIButton.Configuration.filled()
        
        let titleString = AttributedString(type.title, attributes: .init(
            [.font: type.font,
             .foregroundColor: UIColor.white
            ]
        ))
        config.attributedTitle = titleString
        
        self.tintColor = type.backgroundColor

        config.baseBackgroundColor = self.isEnabled == true ? type.backgroundColor : type.resolvedBackgroundColor(isEnabled: false)
        
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
        config.baseForegroundColor = .white
        configuration = config
    }
}
