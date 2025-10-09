//
//  CollegeInfoViewController.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import UIKit
import SwiftUI
import Combine

import DesignSystem
import Shared
import UniversityInfoInterface

import SnapKit
import Then

final class CollegeInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var type: UniversityType
    weak var coordinator: UniversityInfoCoordinating?
    private var viewModel: CollegeInfoViewModel
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar: CustomNavigationView
    private let titleView: InformationTitleView
    private let terbuckBottomButton: TerbuckBottomButton
    private let hostingController: UIHostingController<CollegeSectionView>
    
    // MARK: - Init
    
    public init(
        type: UniversityType,
        viewModel: CollegeInfoViewModel,
        coordinator: UniversityInfoCoordinating
    ) {
        self.type = type
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.customNavBar = CustomNavigationView(type: .nomal, title: type.title)
        self.titleView = InformationTitleView(type: .major(""))
        self.terbuckBottomButton = TerbuckBottomButton(type:  type == .register ? .enter : .save, isEnabled: false)
        
        self.hostingController = UIHostingController(rootView: CollegeSectionView(viewModel: viewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppLogger.log("MajorInfoViewController Deinit", .info, .ui)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        viewLifeCycleSubject.send(.viewDidLoad)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideCustomTabBar()
    }
}

// MARK: - Private Bind Extensions

private extension CollegeInfoViewController {
    func bindViewModel() {
        let input = CollegeInfoViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            bottomButtonTapped: terbuckBottomButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buttonResult in
                if buttonResult {
                    self?.coordinator?.didFinishUniversityInfo()
                }
            }
            .store(in: &cancellables)
        
        output.isBottomButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buttonState in
                guard let self else { return }
                terbuckBottomButton.isUserInteractionEnabled = buttonState
            }
            .store(in: &cancellables)
        
        viewModel.selectedUniversityNameSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self else { return }
                titleView.setupTitleText(name)
            }
            .store(in: &cancellables)
        
        viewModel.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorcase in
                self?.showConfirmAlert(
                    mainTitle: errorcase.errorDescription,
                    subTitle: "잠시 후 다시 시도해주세요\n",
                    centerButton: TerbuckBottomButton(type: .confirm)
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension CollegeInfoViewController {
    func setupStyle() {
        view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.coordinator?.backNavigation()
        }
    }
    
    func setupHierarchy() {
        addChild(hostingController)
        view.addSubviews(customNavBar, titleView, hostingController.view, terbuckBottomButton)
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
        
        terbuckBottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(8))
        }
        
        hostingController.view.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(view.convertByHeightRatio(120))
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.convertByHeightRatio(360))
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("MajorInfoViewController") {
//    MajorInfoViewController(coordinator: any UniversityInfoCoordinating)
//        .showPreview()
//}
//#endif
