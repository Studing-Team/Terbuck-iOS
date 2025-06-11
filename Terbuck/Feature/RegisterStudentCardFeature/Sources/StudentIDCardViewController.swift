//
//  StudentIDCardViewController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class StudentIDCardViewController: UIViewController {
    
    // MARK: - Properties
    
    private let authType: AuthStudentType
    private var holeLocation: CGRect?
    weak var coordinator: StudentIDCardFlowDelegate?
    
    // MARK: - UI Properties
    
    private let studentIdSection = ExampleStudentIDView()
    private lazy var closeButton = UIButton()
    private lazy var underlineLabel = TerbuckUnderlineLabel()
    
    private lazy var onboardingTitle = UILabel()
    private lazy var studentImageView = UIImageView()
    private lazy var arrowImage = UIImageView()
    private lazy var registerButton = TerbuckBottomButton(type: .register)
    private lazy var nextTimeButton = UIButton()
    
    // MARK: - Init
    
    public init(
        authType: AuthStudentType,
        location: CGRect? = nil,
        coordinator: StudentIDCardFlowDelegate
    ) {
        self.authType = authType
        self.holeLocation = location
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        studentIdSection.transform = CGAffineTransform(rotationAngle: .pi / 2)
        setupBackground()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonAction()
        setupStudentIdCard()
    }
}

// MARK: - Private Extensions

private extension StudentIDCardViewController {
    func setupStyle() {
        switch authType {
        case .auth:
            closeButton.do {
                var config = UIButton.Configuration.filled()
                
                let attributedString = AttributedString("닫기", attributes: .init([
                        .font: DesignSystem.Font.uiFont(.textSemi14),
                        .foregroundColor: DesignSystem.Color.uiColor(.terbuckBlack30)
                    ]
                ))
                
                config.attributedTitle = attributedString
                config.baseBackgroundColor = DesignSystem.Color.uiColor(.terbuckBlack10)
                config.cornerStyle = .capsule
                $0.configuration = config
            }
            
            underlineLabel.do {
                $0.text = "학생증 재등록"
                $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack10)
                $0.font = DesignSystem.Font.uiFont(.captionRegular11)
                $0.underlineColor = DesignSystem.Color.uiColor(.terbuckBlack10)
                $0.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerAction))
                $0.addGestureRecognizer(tapGesture)
            }
            
            studentImageView.do {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
                $0.layer.cornerRadius = 16
                $0.layer.borderWidth = 1
                $0.layer.borderColor = DesignSystem.Color.uiColor(.terbuckBlack10).cgColor
            }
            
        case .onboarding:
            studentIdSection.do {
                $0.layer.cornerRadius = 16
                $0.layer.borderWidth = 1
                $0.layer.borderColor = DesignSystem.Color.uiColor(.terbuckBlack10).cgColor
            }
            
            arrowImage.do {
                $0.image = .onboardingArrow
                $0.contentMode = .scaleAspectFill
            }
            
            onboardingTitle.do {
                let fullText = "학생증을 등록하고,\n우리 대학의 특별한 혜택을 받아보세요!"
                let highlightText = "학생증을 등록"

                let attributedString = NSMutableAttributedString(string: fullText, attributes: [
                    .font: DesignSystem.Font.uiFont(.textRegular14),
                    .foregroundColor: DesignSystem.Color.uiColor(.terbuckWhite)
                ])

                if let range = fullText.range(of: highlightText) {
                    let nsRange = NSRange(range, in: fullText)
                    attributedString.addAttribute(.foregroundColor, value: DesignSystem.Color.uiColor(.terbuckGreen50), range: nsRange)
                }

                $0.attributedText = attributedString
                $0.numberOfLines = 2
            }
            
            nextTimeButton.do {
                $0.setTitle("다음에", for: .normal)
                $0.setTitleColor(DesignSystem.Color.uiColor(.terbuckBlack5), for: .normal)
                $0.titleLabel?.font = DesignSystem.Font.uiFont(.textMedium18)
            }
        }
    }
    
    func setupBackground() {
        switch authType {
        case .auth:
            view.backgroundColor = DesignSystem.Color.uiColor(.terbuckStudentBackground)
            
        case .onboarding:
            guard let frame = holeLocation?.insetBy(dx: -8, dy: -8) else { return }
            let overlayView = GuideOverlayView(holeRect: frame, cornerRadius: 55/2)
            view.addSubview(overlayView)
        }
    }
    
    func setupHierarchy() {
        switch authType {
        case .auth:
            view.addSubviews(studentImageView, closeButton, underlineLabel)
            
        case .onboarding:
            view.addSubviews(onboardingTitle, arrowImage, studentIdSection, registerButton, nextTimeButton)
        }
    }
    
    func setupLayout() {
        switch authType {
        case .auth:
            studentImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.height.equalTo(self.view.convertByWidthRatio(294))
                $0.width.equalTo(self.view.convertByHeightRatio(472))
            }
            
            closeButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(145)
                $0.height.equalTo(view.convertByHeightRatio(33))
            }
            
            underlineLabel.snp.makeConstraints {
                $0.top.equalTo(closeButton.snp.bottom).offset(view.convertByHeightRatio(16))
                $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(80))
                $0.centerX.equalToSuperview()
            }
            
        case .onboarding:
            onboardingTitle.snp.makeConstraints {
                $0.top.equalToSuperview().offset(view.convertByHeightRatio(121))
                $0.leading.equalToSuperview().offset(view.convertByHeightRatio(50))
            }
            
            arrowImage.snp.makeConstraints {
                $0.leading.equalTo(onboardingTitle.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().inset(64)
                $0.bottom.equalTo(onboardingTitle.snp.bottom).inset(4)
            }
            
            studentIdSection.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            registerButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            nextTimeButton.snp.makeConstraints {
                $0.top.equalTo(registerButton.snp.bottom).offset(view.convertByHeightRatio(2))
                $0.horizontalEdges.equalToSuperview().inset(50)
                $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(44))
                $0.height.equalTo(52)
            }
        }
    }
    
    func setupButtonAction() {
        switch authType {
        case .auth:
            closeButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            
        case .onboarding:
            nextTimeButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        }
    }
    
    func setupStudentIdCard() {
        guard let imageData = FileStorageManager.shared.load(type: .studentIdCard) else { return }
        studentImageView.image = UIImage(data: imageData)
    }
    
    @objc func cancelAction() {
        dismiss(animated: false)
    }
    
    @objc func registerAction() {
        self.coordinator?.dismissAuthStudentID()
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("StudentIDCardViewController") {
//    StudentIDCardViewController(authType: .onboarding)
//        .showPreview()
//}
//#endif
