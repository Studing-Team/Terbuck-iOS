//
//  DetailStoreInfoViewController.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import UIKit
import SwiftUI

import DesignSystem
import Shared

import SnapKit
import Then

public final class DetailStoreInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private let detailStoreViewModel: DetailStoreInfoViewModel
    private var isShowModal: Bool = false
    weak var coordinator: StoreCoordinator?
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .benefitStore, title: "제휴 혜택")
    private let naverMovementButton = DesignSystem.Button.naverMovementButton()
    private var hostingController: UIHostingController<DetailStoreInfoView>!
    
    private let backgroundView = UIView()
    private var bottomSheetVC: DetailBenefitListModalViewController?
    
    // MARK: - Init
    
    init(
        detailStoreViewModel: DetailStoreInfoViewModel,
        coordinator: StoreCoordinator
    ) {
        self.detailStoreViewModel = detailStoreViewModel
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

        Task {
            await detailStoreViewModel.fetchDetailStoreBenefitData()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ToastManager.shared.showToast(from: self, type: .moreBenefit)
        
        detailStoreViewModel.onUseagesListModalChanged = { [weak self] isPresented in
            if isPresented {
                self?.showConfirmAlert(
                    mainTitle: "이용방법",
                    subTitle: self?.detailStoreViewModel.storeUsagesList.joined(separator: "\n"),
                    centerButton: TerbuckBottomButton(type: .close(type: .alert), isEnabled: true),
                    centerButtonHandler: {
                        self?.dismiss(animated: false)
                        self?.detailStoreViewModel.isUseagesListModal = false
                    }
                )
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.applyGradient(
            colors: [DesignSystem.Color.uiColor(.terbuckWhite), DesignSystem.Color.uiColor(.terbuckGreen50).withAlphaComponent(0.8)],
            direction: .topToBottom
        )
    }
}

// MARK: - Private Extensions

private extension DetailStoreInfoViewController {
    func setupStyle() {
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        naverMovementButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        backgroundView.do {
            $0.backgroundColor = .clear
        }
        
        customNavBar.setupRightButtonAction {
            if UserDefaultsManager.shared.bool(for: .isStudentIDAuthenticated) {
                self.coordinator?.showAuthStudentID()
            } else {
                ToastManager.shared.showToast(from: self, type: .notAuthorized(type: .detailStore)) {
                    self.coordinator?.registerStudentID()
                }
            }
        }
    }
    
    func setupHierarchy() {
        hostingController = UIHostingController(
            rootView: DetailStoreInfoView(
                viewModel: detailStoreViewModel,
                type: .benefitStore,
                onImageTapped: { [weak self] index in
                    guard let self else { return }
                    
                    detailStoreViewModel.tappendImageSection(index: index)
                    self.coordinator?.showPreviewImage(vm: self.detailStoreViewModel)
                },
                onMoreBenefitTapped: { [weak self] moreBenefit in
                    self?.bottomSheetVC = DetailBenefitListModalViewController(moreBenefitListData: moreBenefit)
                    
                    guard let self, let bottomSheetVC else { return }
                    addChild(bottomSheetVC)
                    view.addSubview(bottomSheetVC.view)
                    bottomSheetVC.didMove(toParent: self)
                    
                    bottomSheetVC.delegate = self
                    
                    bottomSheetVC.view.frame = CGRect(
                        x: 0,
                        y: view.bounds.height,  // 아래에서 시작
                        width: view.bounds.width,
                        height: view.bounds.height
                    )

                    // 올라오는 애니메이션
                    UIView.animate(withDuration: 0.3) {
                        bottomSheetVC.view.frame.origin.y = 0
                    }
                }
            )
        )
        
        addChild(hostingController)

        view.addSubviews(customNavBar, hostingController.view, backgroundView, naverMovementButton)

        hostingController.didMove(toParent: self)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        hostingController.view.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }

        naverMovementButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(8))
        }
    }
    
    func setupDelegate() {
        
    }
    
    @objc func buttonTapped() {
        guard let url = URL(string: detailStoreViewModel.storeURL ?? ""),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension DetailStoreInfoViewController: BottomSheetDelegate {
    func didRequestDismissBottomSheet() {
        guard let bottomSheetVC else { return }
        
        UIView.animate(withDuration: 0.3) {
            bottomSheetVC.view.frame.origin.y = self.view.bounds.height
        } completion: { [weak self] _ in
            self?.detailStoreViewModel.isShowModal = false
            self?.detailStoreViewModel.selectedBenefitIndex = nil
            bottomSheetVC.willMove(toParent: nil)
            bottomSheetVC.view.removeFromSuperview()
            bottomSheetVC.removeFromParent()
        }
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("DetailStoreInfoViewController") {
//    DetailStoreInfoViewController()
//        .showPreview()
//}
//#endif
