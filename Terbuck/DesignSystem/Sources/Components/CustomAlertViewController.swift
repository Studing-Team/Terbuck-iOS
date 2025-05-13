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
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let titleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let mainTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
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
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("deinit CustomAlertViewController")
        #endif
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckAlertBackground)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelBackgroundAction)))
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonActions()
    }
}

// MARK: - Private Extensions

private extension CustomAlertViewController {
     func setupStyle() {
         alertBackgroundView.do {
             $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
             $0.layer.cornerRadius = 16
         }
         
         titleStackView.do {
             $0.axis = .vertical
             $0.spacing = 20
             $0.distribution = .fillProportionally
         }
         
         bottomStackView.do {
             $0.axis = .horizontal
             $0.spacing = alertStyle == .twoButton ? 10 : 0
             $0.distribution = .fillEqually
         }
         
         mainTitleLabel.do {
             $0.text = mainTitle
             $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
             $0.font = DesignSystem.Font.uiFont(.textSemi16)
             $0.textAlignment = .center
             $0.numberOfLines = 0
         }
         
         subTitleLabel.do {
             $0.numberOfLines = 2
             $0.textAlignment = .center
             
             let paragraph = NSMutableParagraphStyle()
             paragraph.lineSpacing = 3
             paragraph.alignment = .center
             
             let attrText = NSAttributedString(
                string: subTitle ?? "",
                 attributes: [
                     .font: DesignSystem.Font.uiFont(.textRegular14),
                     .foregroundColor: DesignSystem.Color.uiColor(.terbuckBlack40),
                     .paragraphStyle: paragraph
                 ]
             )
             
             $0.attributedText = attrText
             $0.isHidden = subTitleLabel.text?.isEmpty ?? true
         }
     }
     
     func setupHierarchy() {
         view.addSubview(alertBackgroundView)
         alertBackgroundView.addSubviews(titleStackView, bottomStackView)
         titleStackView.addArrangedSubviews(mainTitleLabel, subTitleLabel)
         
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
     
     func setupLayout() {
         alertBackgroundView.snp.makeConstraints {
             $0.center.equalToSuperview()
             $0.horizontalEdges.equalToSuperview().inset(38)
         }
         
         titleStackView.snp.makeConstraints {
             $0.top.equalToSuperview().inset(35)
             $0.horizontalEdges.equalToSuperview().inset(20)
         }
         
         bottomStackView.snp.makeConstraints {
             $0.top.equalTo(titleStackView.snp.bottom).offset(34)
             $0.horizontalEdges.equalToSuperview().inset(20)
             $0.bottom.equalToSuperview().inset(15)
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
