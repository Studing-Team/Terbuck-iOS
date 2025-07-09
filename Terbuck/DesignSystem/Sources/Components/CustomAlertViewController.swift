//
//  CustomAlertViewController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/18/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    public enum AlertStyle {
        case oneButton
        case twoButton
    }
    
    public typealias ButtonAction = () -> Void
    
    private var mainTitle: String
    private var subTitle: String?
    
    private var leftButtonHandler: ButtonAction?
    private var rightButtonHandler: ButtonAction?
    private var centerButtonHandler: ButtonAction?
    
    private let leftButton: TerbuckBottomButton?
    private let rightButton: TerbuckBottomButton?
    private let centerButton: TerbuckBottomButton?
    
    private var alertStyle: AlertStyle {
        if leftButton != nil && rightButton != nil {
            return .twoButton
        } else {
            return .oneButton
        }
    }
    
    private var isSubTitleForHidden: Bool
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let titleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let mainTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let subTitleTextView = UITextView()
    
    // MARK: - Init
    
    init(
        mainTitle: String,
        subTitle: String?,
        leftButton: TerbuckBottomButton? = nil,
        rightButton: TerbuckBottomButton? = nil,
        centerButton: TerbuckBottomButton? = nil,
        leftButtonHandler: ButtonAction? = nil,
        rightButtonHandler: ButtonAction? = nil,
        centerButtonHandler: ButtonAction? = nil
    ) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.centerButton = centerButton
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.centerButtonHandler = centerButtonHandler
        self.isSubTitleForHidden = subTitle == nil ? true : false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppLogger.log("CustomAlertViewController Deinit", .info, .ui)
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        AppLogger.log("CustomAlertViewController ViewDidLoad", .info, .ui)
        
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckAlertBackground)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelBackgroundAction)))
        
        setupStyle()
        setupHierarchy(isHidden: isSubTitleForHidden)
        setupLayout(isHidden: isSubTitleForHidden)
        setupButtonActions()
        
        if !isSubTitleForHidden {
            let targetWidth = UIScreen.main.bounds.width - 38 * 2 - 25 * 2
            let size = subTitleTextView.sizeThatFits(CGSize(width: targetWidth, height: .greatestFiniteMagnitude))
         
            if size.height > 114 {
                subTitleTextView.isScrollEnabled = true
            } else {
                subTitleTextView.isScrollEnabled = false
            }
            
            // SnapKit 업데이트
            subTitleTextView.snp.remakeConstraints {
                $0.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(min(size.height, 114))
            }
            
            view.layoutIfNeeded()
        }
    }
}

// MARK: - Private Extensions

private extension CustomAlertViewController {
    func setupStyle() {
        alertBackgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            $0.layer.cornerRadius = 16
        }
        
        mainTitleLabel.do {
            $0.text = mainTitle
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        subTitleTextView.do {
            $0.text = subTitle
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack40)
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textAlignment = .center
            $0.isEditable = false
            $0.isScrollEnabled = false   // 여기서 자체 스크롤 가능
            $0.isHidden = (subTitle?.isEmpty ?? true)
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
        }
        
        bottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = alertStyle == .twoButton ? 10 : 0
            $0.distribution = .fillEqually
        }
    }

    func setupHierarchy(isHidden: Bool) {
        view.addSubview(alertBackgroundView)
        
        if isHidden {
            alertBackgroundView.addSubviews(mainTitleLabel, bottomStackView)
        } else {
            alertBackgroundView.addSubviews(mainTitleLabel, subTitleTextView, bottomStackView)
        }

        switch alertStyle {
        case .twoButton:
            if let leftButton, let rightButton {
                bottomStackView.addArrangedSubviews(leftButton, rightButton)
            }
        case .oneButton:
            if let centerButton {
                bottomStackView.addArrangedSubview(centerButton)
            }
        }
    }
    
    func setupLayout(isHidden: Bool) {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(38)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        if isHidden {
            bottomStackView.snp.makeConstraints {
                $0.top.equalTo(mainTitleLabel.snp.bottom).offset(35)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(15)
            }
        } else {
            subTitleTextView.snp.makeConstraints {
                $0.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.greaterThanOrEqualTo(40)
                $0.height.lessThanOrEqualTo(114)
            }
            
            bottomStackView.snp.makeConstraints {
                $0.top.equalTo(subTitleTextView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(15)
            }
        }
        
        [leftButton, rightButton, centerButton].forEach {
            $0?.snp.makeConstraints {
                $0.height.equalTo(39)
            }
        }
    }
     
     func setupButtonActions() {
         leftButton?.buttonAction = { [weak self] in
             self?.leftButtonHandler?() ?? self?.dismiss(animated: false)
         }
         
         rightButton?.buttonAction = { [weak self] in
             self?.rightButtonHandler?() ?? self?.dismiss(animated: false)
         }
         
         centerButton?.buttonAction = { [weak self] in
             self?.centerButtonHandler?() ?? self?.dismiss(animated: false)
         }
     }
     
     @objc func cancelBackgroundAction() {
         dismiss(animated: false)
     }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("CustomAlertViewController") {
//    CustomAlertViewController(
//        mainTitle: "로그아웃 하시곘습니까?",
//        leftButton: <#T##TerbuckBottomButton?#>,
//        rightButton: TerbuckBottomButton?,
//        centerButton:
//    )
//        .showPreview()
//}
//#endif
