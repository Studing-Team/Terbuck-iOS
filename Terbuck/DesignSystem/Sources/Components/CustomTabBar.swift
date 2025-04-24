//
//  CustomTabBar.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/24/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class CustomTabBar: UITabBar {
    
    // MARK: - Property
    
    private var selectedIndex: Int = 0
    public var onTabSelected: ((TabBarType) -> Void)?
    
    // MARK: - UI Components
    
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    private let topSeparator = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        // 아무것도 그리지 않음 → 기본 라인 제거
    }
}

// MARK: - Private Extensions

private extension CustomTabBar {
    func setupStyle() {
        self.backgroundColor = .terbuckWhite
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 75
        }
        
        topSeparator.backgroundColor = .terbuckWhite3
    }
    
    func setupHierarchy() {
        addSubviews(topSeparator, stackView)
    }
    
    func setupLayout() {
        topSeparator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(23)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
    }
    
    private func setupButtons() {
        TabBarType.allCases.enumerated().forEach { index, type in
            let button = makeTabButton(index: index, type: type, isSelected: index == 0)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    private func makeTabButton(index: Int, type: TabBarType, isSelected: Bool) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = isSelected ? type.selectedImage : type.image
        config.baseForegroundColor = isSelected ? .terbuckDarkGray50 : .terbuckDarkGray10
        
        config.title = type.title
        config.attributedTitle = AttributedString(type.title, attributes: AttributeContainer([
            .font: UIFont.captionMedium12
        ]))
        
        config.imagePlacement = .top
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0)

        let button = UIButton(configuration: config)
        button.tag = index
        return button
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedIndex = index
        
        buttons.enumerated().forEach { i, btn in
            let type = TabBarType.allCases[i]
            btn.configuration?.image = i == index ? type.selectedImage : type.image
            btn.configuration?.baseForegroundColor = i == index ? .terbuckDarkGray50 : .terbuckDarkGray10
        }
        
        onTabSelected?(TabBarType.allCases[index])
    }
}
