//
//  AlarmInfomationView.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit

import DesignSystem
import Shared

import SnapKit
import Then

public final class AlarmInfomationView: UIView {

    // MARK: - Properties

    private var alarmButtonAction: (() -> Void)?

    // MARK: - UI Properties

    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let alarmSettingButton = UIButton(type: .system)

    // MARK: - Init

    public init() {
        super.init(frame: .zero)

        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeAlarmState(isAlarm: Bool) {
        updateButtonLayout(isAlarm)
    }

    func updateButtonLayout(_ isAlarm: Bool) {
        var config = UIButton.Configuration.filled()

        // 텍스트 설정
        let titleString = AttributedString(isAlarm ? "알림 끄기" : "알림 켜기", attributes: .init(
            [.font: DesignSystem.Font.uiFont(.captionMedium12)]
        ))

        config.attributedTitle = titleString
        config.baseBackgroundColor = DesignSystem.Color.uiColor(isAlarm ? .terbuckBlack5 : .terbuckGreen50)
        config.baseForegroundColor = .white

        alarmSettingButton.layer.cornerRadius = 8
        alarmSettingButton.clipsToBounds = true
        alarmSettingButton.configuration = config
    }

    func setAlarmSettingAction(_ action: @escaping () -> Void) {
        self.alarmButtonAction = action

        // 기존에 설정된 Target을 제거한 후, 새로운 Target 추가 (중복 방지)
        alarmSettingButton.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        alarmSettingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        alarmButtonAction?()
        MixpanelManager.shared.track(eventType: TrackEventType.Mypage.alarmSettingButtonTapped)
    }
}

// MARK: - Private Extensions

private extension AlarmInfomationView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite3)
            $0.layer.cornerRadius = 20
        }

        titleLabel.do {
            $0.text = "알림을 켜주세요"
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
            $0.font = DesignSystem.Font.uiFont(.textSemi14)
        }

        subTitleLabel.do {
            $0.text = "제휴 업체 업데이트 소식을 받아보세요"
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
            $0.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.numberOfLines = 0
        }
    }

    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel, alarmSettingButton)
    }

    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(alarmSettingButton.snp.leading)
            $0.bottom.equalToSuperview().inset(21.5)
        }

        alarmSettingButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24.5)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(69)
        }
    }
}
