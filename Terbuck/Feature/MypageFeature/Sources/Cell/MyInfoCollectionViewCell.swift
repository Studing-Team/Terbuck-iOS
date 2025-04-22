//
//  MyInfoCollectionViewCell.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/17/25.
//

import UIKit

import DesignSystem

import SnapKit
import Then

public final class MyInfoCollectionViewCell: UICollectionViewCell {
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

public extension MyInfoCollectionViewCell {
    func configureCell(forModel model: UserInfoModel) {
        nameLabel.text = model.userName
        universityLabel.text = model.university
        studentIdLabel.text = model.studentId
        
        updateStyle(isAuth: model.isAuthenticated)
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
            $0.font = .textSemi18
            $0.textColor = .terbuckWhite
        }
        
        [studentIdLabel, nameLabel].forEach {
            $0.font = .textRegular14
            $0.textColor = .terbuckWhite3
        }
        
        authStudentButton.do {
            $0.setImage(.writeIcon, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
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
        contentView.backgroundColor = isAuth ? .terbuckGreen50 : .terbuckBlack10
        self.userInfoStackView.isHidden = !isAuth
    }
}
