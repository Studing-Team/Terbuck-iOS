//
//  ChangeUniversityViewController.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

public final class ChangeUniversityViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: ChangeUniversityViewModel
    weak var coordinator: MypageCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "학교 변경")
    private let titleView = InformationTitleView(type: .university)
    
    private let universityListStackView = UIStackView()
    
    private let kwUniversityView = UniversityListView(type: .kw)
    private let ssUniversityView = UniversityListView(type: .ss)
    
    private let terbuckBottomButton = TerbuckBottomButton(type: .save, isEnabled: false)
    
    // MARK: - Init
    
    public init(
        viewModel: ChangeUniversityViewModel,
        coordinator: MypageCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
}

// MARK: - Private Bind Extensions

private extension ChangeUniversityViewController {
    func bindViewModel() {
        let universityTappedPublisher = Publishers.Merge(
            kwUniversityView.tapPublisher.map { _ in University.kw },
            ssUniversityView.tapPublisher.map { _ in University.ss }
        )
        .eraseToAnyPublisher()
        
        kwUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.viewModel.universitySubject.send("광운대학교")
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.viewModel.universitySubject.send(nil)
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        ssUniversityView.tapPublisher
            .sink { [weak self] value in
                if value {
                    self?.viewModel.universitySubject.send("서울과학기술대학교")
                    self?.terbuckBottomButton.isUserInteractionEnabled = true
                } else {
                    self?.viewModel.universitySubject.send(nil)
                    self?.terbuckBottomButton.isUserInteractionEnabled = false
                }
            }
            .store(in: &cancellables)
        
        let input = ChangeUniversityViewModel.Input(
            universityTapped: universityTappedPublisher,
            bottomButtonTapped: terbuckBottomButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedUniversity
            .sink { [weak self] selected in
                guard let self else { return }
                
                switch selected {
                case .kw:
                    self.ssUniversityView.changeButtonState(isSelect: false)
                case .ss:
                    self.kwUniversityView.changeButtonState(isSelect: false)
                default:
                    break
                }

                self.terbuckBottomButton.isUserInteractionEnabled = selected != nil
            }
            .store(in: &cancellables)
        
        output.bottomButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.changeUniversityError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                switch error {
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension ChangeUniversityViewController {
    func setupStyle() {
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        universityListStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.addArrangedSubviews(kwUniversityView, ssUniversityView)
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
        
        [kwUniversityView, ssUniversityView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}
