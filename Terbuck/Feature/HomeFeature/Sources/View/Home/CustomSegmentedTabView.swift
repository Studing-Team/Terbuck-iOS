//
//  CustomSegmentedTabView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 4/22/25.
//

import UIKit
import Combine

import DesignSystem

import SnapKit
import Then

public final class SegmentedTabView: UIView {
    
    // MARK: - Properties
    
    private var selectedType: StoreFilterType = .restaurent
    
    // MARK: - Combine Properties
    
    private let selectedFilterSubject = PassthroughSubject<StoreFilterType, Never>()
    public var selectedFilterPublisher: AnyPublisher<StoreFilterType, Never> {
        selectedFilterSubject.eraseToAnyPublisher()
    }
    private var didInitialLayout = false
    
    // MARK: - UI Properties
    
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    private let indicatorView = UIView()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !didInitialLayout else { return }
        didInitialLayout = true

        DispatchQueue.main.async {
            self.selectSegment(type: self.selectedType, animated: false)
        }
    }
}


// MARK: - Private Extensions

private extension SegmentedTabView {
    func setupStyle() {
        self.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        indicatorView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowRadius = 30
            $0.layer.shadowOffset = CGSize(width: 1, height: 1)
            $0.layer.shadowColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(indicatorView, stackView)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureButtons() {
        StoreFilterType.allCases.enumerated().forEach { index, type in
            let button = createButton(type: type)
            button.tag = index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            button.configurationUpdateHandler = { button in
                
                var updatedConfig = button.configuration
                
                // 선택 상태에 따라 다른 색상 적용
                let textColor = button.isSelected ? DesignSystem.Color.uiColor(.terbuckBlack30) : DesignSystem.Color.uiColor(.terbuckBlack10)
                
                updatedConfig?.attributedTitle = AttributedString(type.title, attributes: AttributeContainer([
                    .font: DesignSystem.Font.uiFont(.textSemi14),
                    .foregroundColor: textColor
                ]))
                
                if type == .partnership && button.isSelected == true {
                    updatedConfig?.image = .selectedPartnership
                    updatedConfig?.imagePlacement = .trailing
                    updatedConfig?.imagePadding = 1.5
                } else {
                    updatedConfig?.image = nil
                }
                
                button.configuration = updatedConfig
            }
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    // 기본 버튼 생성 함수 (초기 설정만 포함)
    func createButton(type: StoreFilterType) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = type.title
        config.baseBackgroundColor = .clear
        
        config.attributedTitle = AttributedString(type.title, attributes: AttributeContainer([
            .font: DesignSystem.Font.uiFont(.textSemi14),
            .foregroundColor: DesignSystem.Color.uiColor(.terbuckBlack10)
        ]))

        button.configuration = config
        button.isSelected = type == selectedType // 초기 선택 상태 설정
        
        return button
    }
    
    @objc private func segmentTapped(_ sender: UIButton) {
        let type = StoreFilterType.allCases[sender.tag]
        selectSegment(type: type)
        selectedFilterSubject.send(type)
    }

    func selectSegment(type: StoreFilterType, animated: Bool = true) {
        guard let index = StoreFilterType.allCases.firstIndex(of: type) else { return }
        
        let button = buttons[index]
        selectedType = type

        let insetFrame = button.frame.insetBy(dx: 4, dy: 4)

        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.indicatorView.frame = insetFrame
        }

        for (i, btn) in buttons.enumerated() {
            let isSelected = i == index
            btn.isSelected = isSelected
        }
        
        self.layoutIfNeeded()
    }
}
