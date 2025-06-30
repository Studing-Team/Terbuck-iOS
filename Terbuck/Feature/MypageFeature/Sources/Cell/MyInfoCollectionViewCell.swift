//
//  MyInfoCollectionViewCell.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/17/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class MyInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var buttonAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let myInfoVerticalStackView = UIStackView()
    private let userInfoStackView = UIStackView()
    private let universityLabel = UILabel()
    private let studentIdLabel = UILabel()
    private let nameLabel = UILabel()
    private let emptyView = UIView()
    
    private let authStudentButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

public extension MyInfoCollectionViewCell {
    func configureCell(forModel model: UserInfoModel?) {
        if let model {
            nameLabel.text = model.userName
            universityLabel.text = model.university
            studentIdLabel.text = model.studentId
            
            updateStyle(isAuth: model.isAuthenticated)
        } else {
            updateStyle(isAuth: false)
            universityLabel.text = UserDefaultsManager.shared.string(for: .university)
        }
    }
    
    func bindingAction(action: @escaping () -> Void) {
        buttonAction = action
    }
}

// MARK: - Private Extensions

private extension MyInfoCollectionViewCell {
    func setupStyle() {
        contentView.layer.cornerRadius = 16
        
        myInfoVerticalStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.addArrangedSubviews(universityLabel, userInfoStackView)
        }
        
        userInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.addArrangedSubviews(studentIdLabel, nameLabel, emptyView)
        }
        
        universityLabel.do {
            $0.font = DesignSystem.Font.uiFont(.textSemi18)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckWhite)
        }
        
        [studentIdLabel, nameLabel].forEach {
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckWhite3)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(myInfoVerticalStackView, authStudentButton)
    }
    
    func setupLayout() {
        myInfoVerticalStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        authStudentButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
    
    func updateStyle(isAuth: Bool) {
        contentView.backgroundColor = DesignSystem.Color.uiColor(isAuth ? .terbuckGreen50 : .terbuckBlack10)
        
        authStudentButton.do {
            let icon: UIImage = isAuth == true ? .writeIcon : .notAuthWriteIcon
            $0.setImage(icon, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        if isAuth {
            if !myInfoVerticalStackView.arrangedSubviews.contains(userInfoStackView) {
                myInfoVerticalStackView.addArrangedSubview(userInfoStackView)
            }
        } else {
            if myInfoVerticalStackView.arrangedSubviews.contains(userInfoStackView) {
                myInfoVerticalStackView.removeArrangedSubview(userInfoStackView)
                userInfoStackView.removeFromSuperview()
            }
        }
    }
    
    func setupButtonAction() {
        authStudentButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
    }
    
    @objc func authAction() {
        buttonAction?()
        MixpanelManager.shared.track(eventType: TrackEventType.Mypage.editUniversityButtonTapped)
    }
}
