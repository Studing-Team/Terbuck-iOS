//
//  RegisterStudentCardViewController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class RegisterStudentCardViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "학생증 등록")
    private let registerStudentIDCardButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let bottomButton = TerbuckBottomButton(type: .register)
    
    private let textFieldStackView = UIStackView()
    private let nameTextFieldView = TerbuckTextFieldView(type: .name)
    private let studentIdTextFieldView = TerbuckTextFieldView(type: .studentID)
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonAction()
        
        setupKeyboardHandling()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("RegisterStudentCardViewController viewWillAppear")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("RegisterStudentCardViewController viewDidAppear")
        
        ToastManager.shared.showToast(from: self, type: .noticeStudentCard)
    }
}

// MARK: - Private Extensions

private extension RegisterStudentCardViewController {
    func setupStyle() {
        self.view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        titleLabel.do {
            $0.text = "혜택을 받기 위해\n학생증을 등록해주세요"
            $0.font = DesignSystem.Font.uiFont(.titleSemi20)
            $0.numberOfLines = 2
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        subTitleLabel.do {
            $0.text = "학생증 등록은 24시간 안에 마무리 할게요 :)"
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
        }
        
        registerStudentIDCardButton.do {
            $0.setTitle("학생증 이미지 넣기", for: .normal)
            $0.setTitleColor(DesignSystem.Color.uiColor(.terbuckBlack10), for: .normal)
            $0.titleLabel?.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
            $0.layer.cornerRadius = 16
        }
        
        textFieldStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillProportionally
            $0.addArrangedSubviews(nameTextFieldView, studentIdTextFieldView)
        }
        
        bottomButton.isEnabled = true
    }
    
    func setupHierarchy() {
        self.view.addSubviews(customNavBar, titleLabel, subTitleLabel, registerStudentIDCardButton, textFieldStackView, bottomButton)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        registerStudentIDCardButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(230)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(registerStudentIDCardButton.snp.bottom).offset(view.convertByHeightRatio(25))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(8))
        }
    }
    
    func setupButtonAction() {
        registerStudentIDCardButton.addTarget(self, action: #selector(cancelAction), for: .touchDown)
    }
    
    @objc func cancelAction() {
        print("눌림")
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("RegisterStudentCardViewController") {
    RegisterStudentCardViewController()
        .showPreview()
}
#endif
