//
//  TermsOfServiceViewController.swift
//  Login
//
//  Created by ParkJunHyuk on 4/11/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

final class TermsOfServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: TermsOfServiceViewModel
    weak var coordinator: AuthCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "회원가입")
    private let titleView = InformationTitleView(type: .termsView)
    
    private let termsStackView = UIStackView()
    private let serviceTermsView = TermsListView(type: .service)
    private let userInfoTermsView = TermsListView(type: .userInfo)
    
    private let allTermsStackView = UIStackView()
    private let allTermsCheckButton = AuthCheckButton(type: .notBorder)
    private let allTermsTitleLabel = UILabel()
    
    private let terbuckBottomButton = TerbuckBottomButton(type: .next)
    
    // MARK: - Init
    
    init(
        viewModel: TermsOfServiceViewModel,
        coordinator: AuthCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
}

// MARK: - Private Bind Extensions

private extension TermsOfServiceViewController {
    func bindViewModel() {
        let input = TermsOfServiceViewModel.Input(
            serviceTermsTapped: serviceTermsView.tapPublisher.eraseToAnyPublisher(),
            userInfoTermsTapped: userInfoTermsView.tapPublisher.eraseToAnyPublisher(),
            allTermsTapped: allTermsCheckButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.serviceTermsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.serviceTermsView.changeButtonState(isSelect: state)
            }
            .store(in: &cancellables)
        
        output.userInfoTermsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.userInfoTermsView.changeButtonState(isSelect: state)
            }
            .store(in: &cancellables)
        
        /// 모두 동의하기 버튼 활성화 여부 UI 반영
        output.allTermsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.allTermsCheckButton.changeButtonState(isSelect: state)
            }
            .store(in: &cancellables)
        
        /// 약관 3개가 모두 선택 됐을 때 모두 동의하기 버튼 활성화
        output.mergeTermsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.allTermsCheckButton.changeButtonState(isSelect: state)

            }
            .store(in: &cancellables)
        
        output.isBottomButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.terbuckBottomButton.isUserInteractionEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        terbuckBottomButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                MixpanelManager.shared.track(eventType: TrackEventType.Signup.firstSignupButtonTapped)
                self.coordinator?.startUniversity()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension TermsOfServiceViewController {
    func setupStyle() {
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        terbuckBottomButton.isUserInteractionEnabled = false
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        allTermsTitleLabel.do {
            $0.text = "약관 모두 동의"
            $0.font = DesignSystem.Font.uiFont(.textSemi16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        allTermsStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
            $0.addArrangedSubviews(allTermsCheckButton, allTermsTitleLabel)
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
            $0.layer.cornerRadius = 8
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 18.17, bottom: 0, right: 18.17)
        }
        
        termsStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.addArrangedSubviews(serviceTermsView, userInfoTermsView)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(customNavBar, titleView, allTermsStackView, termsStackView, terbuckBottomButton)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(view.convertByHeightRatio(66))
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        allTermsStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(allTermsStackView.snp.bottom).offset(view.convertByHeightRatio(12))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        terbuckBottomButton.snp.makeConstraints {
            $0.top.equalTo(termsStackView.snp.bottom).offset(view.convertByHeightRatio(94))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(12))
        }
        
        [allTermsStackView, serviceTermsView, userInfoTermsView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("TermsOfServiceViewController") {
//    TermsOfServiceViewController()
//        .showPreview()
//}
//#endif
