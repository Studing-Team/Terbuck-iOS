//
//  ArrowImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/18/25.
//

import UIKit

import SnapKit
import Then

public final class ChevronImageView: UIImageView {
    
    // MARK: - Enum Properties
    
    public enum ImageType {
        case size14
        case size20
        
        var size: CGSize {
            switch self {
            case .size14:
                return CGSize(width: 14, height: 14)
            case .size20:
                return CGSize(width: 20, height: 20)
            }
        }
    }
    
    private var type: ImageType

    // MARK: - Init
    
    public init(
        type: ImageType,
        tintColor: UIColor
    ) {
        self.type = type
        super.init(frame: .zero)
        
        setupStyle(tintColor)
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ChevronImageView {
    func setupStyle(_ color: UIColor) {
        self.image = UIImage(systemName: "chevron.right")
        self.tintColor = color
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(type.size.width)
            $0.height.equalTo(type.size.height)
        }
    }
}
