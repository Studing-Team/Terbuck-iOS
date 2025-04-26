//
//  ExampleStudentIDView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit

import Shared

import SnapKit
import Then

public final class ExampleStudentIDView: UIView {
    
    // MARK: - UI Components
    
    private let userKoreaNameLabel = UILabel()
    private let userEnglishNameLabel = UILabel()
    private let universityKoreaLabel = UILabel()
    private let universityEnglishLabel = UILabel()
    
    private let userUniversityInfoStackView = UIStackView()
    private let personImageView = UIImageView()
    
    private let collegeLabel = UILabel()
    private let majorLabel = UILabel()
    private let studentNumberLabel = UILabel()
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .terbuckWhite3
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ExampleStudentIDView {
    func setupStyle() {
        
        userUniversityInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 5.81
            $0.addArrangedSubviews(collegeLabel, majorLabel, studentNumberLabel)
        }
        
        userKoreaNameLabel.do {
            $0.text = "김터벅"
            $0.font = .headBold30
            $0.textColor = .terbuckBlack30
        }
        
        userEnglishNameLabel.do {
            $0.text = "Kim Terbuck"
            $0.font = .textRegular20
            $0.textColor = .terbuckBlack10
        }
        
        personImageView.do {
            $0.image = .person
            $0.contentMode = .scaleAspectFit
        }
        
        [collegeLabel, majorLabel, studentNumberLabel].forEach {
            $0.textColor = .terbuckBlack30
            $0.font = .textMedium18
        }
        
        collegeLabel.text = "OO대학"
        majorLabel.text = "OO학과"
        studentNumberLabel.text = "20250000"
        
        universityEnglishLabel.do {
            $0.text = "Terbuck Universuty"
            $0.textColor = .terbuckBlack10
            $0.font = .textRegular20
        }
        
        universityKoreaLabel.do {
            $0.text = "터벅대학교"
            $0.textColor = .terbuckBlack30
            $0.font = .titleSemi26
        }
        
        self.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    func setupHierarchy() {
        self.addSubviews(userKoreaNameLabel, userEnglishNameLabel, personImageView, userUniversityInfoStackView, universityEnglishLabel, universityKoreaLabel)
    }
    
    func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(self.convertByWidthRatio(294))
            $0.width.equalTo(self.convertByHeightRatio(472))
        }
        
        userKoreaNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(40))
            $0.leading.equalToSuperview().offset(35)
        }
        
        userEnglishNameLabel.snp.makeConstraints {
            $0.top.equalTo(userKoreaNameLabel.snp.bottom).offset(convertByHeightRatio(3))
            $0.leading.equalToSuperview().offset(35)
        }
        
        personImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(35)
        }
        
        userUniversityInfoStackView.snp.makeConstraints {
            $0.top.equalTo(userEnglishNameLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(35)
        }
        
        universityEnglishLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35)
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(30))
        }
        
        universityKoreaLabel.snp.makeConstraints {
            $0.top.equalTo(personImageView.snp.bottom).offset(112)
            $0.trailing.equalToSuperview().inset(37)
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(28))
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("ExampleStudentIDView") {
    ExampleStudentIDView()
        .showPreview()
}
#endif
