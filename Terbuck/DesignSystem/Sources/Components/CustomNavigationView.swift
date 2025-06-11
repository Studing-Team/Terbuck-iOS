//
//  CustomNavigationView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit

import Shared

import SnapKit
import Then

public enum CustomNavigationType {
    case nomal
    case previewImage
    case benefitStore
}

public final class CustomNavigationView: UIView {
    
    // MARK: - Properties
    
    private var type: CustomNavigationType
    private var backAction: (() -> Void)?
    private var studentButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let separator = UIView()
    private lazy var studentIDCardButton = DesignSystem.Button.studentIDCardButton()
    
    // MARK: - Init
    
    public init(
        type: CustomNavigationType,
        title: String
    ) {
        self.type = type
        self.titleLabel.text = title
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapBack() {
        backAction?()
    }
    
    @objc private func didStudentButtonTapped() {
        studentButtonAction?()
    }

    public func setupBackButtonAction(_ action: @escaping () -> Void) {
        self.backAction = action
    }
    
    public func setupRightButtonAction(_ action: @escaping () -> Void) {
        self.studentButtonAction = action
    }
}

// MARK: - Private Extensions

private extension CustomNavigationView {
    func setupStyle(_ type: CustomNavigationType) {
        titleLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi18)
            $0.textColor = DesignSystem.Color.uiColor(type == .previewImage ? .terbuckWhite : .terbuckBlack50)
            $0.textAlignment = .center
        }
        
        backButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: type == .previewImage ? "xmark" : "chevron.left", withConfiguration: config)
            $0.setImage(image, for: .normal)
            $0.tintColor = type == .previewImage ? .white : .black
            $0.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        }
        
        separator.do {
            $0.backgroundColor = type == .previewImage ? .black : DesignSystem.Color.uiColor(.terbuckWhite5)
        }
        
        if type == .benefitStore {
            studentIDCardButton.do {
                $0.setImage(UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated) ? .authIdCard : .notAuthIdCard, for: .normal)
                $0.addTarget(self, action: #selector(didStudentButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(backButton, titleLabel, separator)
        
        if type == .benefitStore {
            self.addSubview(studentIDCardButton)
        }
    }

    func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }

        if type == .benefitStore {
            studentIDCardButton.snp.makeConstraints {
                $0.centerY.equalTo(backButton.snp.centerY)
                $0.trailing.equalToSuperview().inset(25)
            }
        }

        separator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.5)
        }
    }
}
