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
    
    public func updateSelectedIndex(to index: Int) {
        selectedIndex = index
        sendMixpanalData(index)
        
        buttons.forEach { button in
            guard let type = TabBarType(rawValue: button.tag) else { return }
            
            let isSelected = button.tag == selectedIndex
            button.configuration?.image = isSelected ? type.selectedImage : type.image
            button.configuration?.baseForegroundColor = isSelected ? DesignSystem.Color.uiColor(.terbuckDarkGray50) : DesignSystem.Color.uiColor(.terbuckDarkGray10)
        }
    }
}

// MARK: - Private Extensions

private extension CustomTabBar {
    func setupStyle() {
        self.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 75
        }
        
        topSeparator.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite3)
        }
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
    
    func setupButtons() {
        TabBarType.allCases.forEach { type in
            let button = makeTabButton(for: type)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        // 초기 선택 상태 설정 (0번째 인덱스)
        updateSelectedIndex(to: 0)
    }
    
    func makeTabButton(for type: TabBarType) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        config.image = type.image
        config.title = type.title
        config.baseForegroundColor = DesignSystem.Color.uiColor(.terbuckDarkGray10)
        config.imagePlacement = .top
        config.imagePadding = 4
        config.attributedTitle = AttributedString(type.title, attributes: AttributeContainer([
            .font: DesignSystem.Font.uiFont(.captionMedium12)
        ]))
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0)
        
        let button = UIButton(configuration: config)
        button.tag = type.rawValue

        return button
    }
    
    func sendMixpanalData(_ index: Int) {
        guard let tab = TabBarType(rawValue: index) else { return }

         switch tab {
         case .home:
             MixpanelManager.shared.track(eventType: TrackEventType.Home.homeTabBarButtonTapped)
         case .store:
             MixpanelManager.shared.track(eventType: TrackEventType.Home.terbuckTabBarButtonTapped)
         case .mypage:
             MixpanelManager.shared.track(eventType: TrackEventType.Home.mypageTabBarButtonTapped)
         }
    }
}
