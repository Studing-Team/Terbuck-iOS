//
//  UniversityInfoViewController.swift
//  Login
//
//  Created by ParkJunHyuk on 4/12/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

final class UniversityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: UniversityViewModel
    weak var coordinator: AuthCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "회원가입")
    private let titleView = InformationTitleView(type: .university)
    
    private let universityListStackView = UIStackView()
    
    private let kwUniversityView = UniversityListView(type: .kw)
    private let ssUniversityView = UniversityListView(type: .ss)
    private let samUniversityView = UniversityListView(type: .sam)
    private let sungUniversityView = UniversityListView(type: .sung)
    
    private let terbuckBottomButton = TerbuckBottomButton(type: .enter, isEnabled: false)
    
    // MARK: - Init
    
    init(
        viewModel: UniversityViewModel,
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

private extension UniversityInfoViewController {
    func bindViewModel() {
        let universityTappedPublisher = Publishers.Merge4(
            kwUniversityView.tapPublisher.map { _ in University.kw },
            ssUniversityView.tapPublisher.map { _ in University.ss },
            samUniversityView.tapPublisher.map { _ in University.sam },
            sungUniversityView.tapPublisher.map { _ in University.sung }
        )
        .eraseToAnyPublisher()
        
        let input = UniversityViewModel.Input(
            universityTapped: universityTappedPublisher,
            signupButtonTapped: terbuckBottomButton.tapPublisher
        )
        
        kwUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        ssUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        samUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        sungUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        let output = viewModel.transform(input: input)
        
        output.selectedUniversity
            .sink { [weak self] selected in
                guard let self else { return }
                
                switch selected {
                case .kw:
                    self.ssUniversityView.changeButtonState(isSelect: false)
                    self.samUniversityView.changeButtonState(isSelect: false)
                    self.sungUniversityView.changeButtonState(isSelect: false)
                case .ss:
                    self.kwUniversityView.changeButtonState(isSelect: false)
                    self.samUniversityView.changeButtonState(isSelect: false)
                    self.sungUniversityView.changeButtonState(isSelect: false)
                case .sam:
                    self.ssUniversityView.changeButtonState(isSelect: false)
                    self.kwUniversityView.changeButtonState(isSelect: false)
                    self.sungUniversityView.changeButtonState(isSelect: false)
                case .sung:
                    self.ssUniversityView.changeButtonState(isSelect: false)
                    self.kwUniversityView.changeButtonState(isSelect: false)
                    self.samUniversityView.changeButtonState(isSelect: false)
                default:
                    break
                }

                self.terbuckBottomButton.isUserInteractionEnabled = selected != nil
            }
            .store(in: &cancellables)
        
        output.signupButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.finishAuthFlow()
                case .failure(_):
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension UniversityInfoViewController {
    func setupStyle() {
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        universityListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.addArrangedSubviews(kwUniversityView, samUniversityView, ssUniversityView, sungUniversityView)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(customNavBar, titleView, universityListStackView, terbuckBottomButton)
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
        
        universityListStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        terbuckBottomButton.snp.makeConstraints {
            $0.top.equalTo(universityListStackView.snp.bottom).offset(view.convertByHeightRatio(90))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(12))
        }
        
        [kwUniversityView, ssUniversityView, samUniversityView, sungUniversityView].forEach {
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
//#Preview("UniversityInfoViewController") {
//    UniversityInfoViewController()
//        .showPreview()
//}
//#endif
