//
//  UniversityViewController.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import UIKit
import SwiftUI
import Combine

import DesignSystem
import Shared
import UniversityInfoInterface

import SnapKit
import Then

public final class UniversityViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var type: UniversityType
    private var viewModel: UniversityViewModel
    public weak var delegate: RegisterUniversityDelegate?
    weak var coordinator: UniversityInfoCoordinating?
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar: CustomNavigationView
    private let titleView = InformationTitleView(type: .university)
    private let hostingController: UIHostingController<InfomationSectionView>
    private let terbuckBottomButton: TerbuckBottomButton
    
    // MARK: - Init
    
    public init(
        type: UniversityType,
        viewModel: UniversityViewModel,
        coordinator: UniversityInfoCoordinating
    ) {
        self.type = type
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.customNavBar = CustomNavigationView(type: .nomal, title: type.title)
        self.terbuckBottomButton = TerbuckBottomButton(type: .next, isEnabled: false)
        
        self.hostingController = UIHostingController(rootView: InfomationSectionView(viewModel: viewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppLogger.log("UniversityViewController Deinit", .info, .ui)
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
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

private extension UniversityViewController {
    func bindViewModel() {
        let input = UniversityViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            bottomButtonTapped: terbuckBottomButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectUniversityName in
                self?.coordinator?.showCollege(selectUniversityName: selectUniversityName)
            }
            .store(in: &cancellables)
        
        output.isBottomButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buttonState in
                guard let self else { return }
                terbuckBottomButton.isUserInteractionEnabled = buttonState
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension UniversityViewController {
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
        
        hostingController.view.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(view.convertByHeightRatio(120))
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.convertByHeightRatio(360))
        }
        
        terbuckBottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(8))
        }
    }
    
    func setupDelegate() {
        
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("UniversityViewController") {
//    UniversityViewController()
//        .showPreview()
//}
//#endif
