//
//  PartnershipViewController.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import UIKit
import SwiftUI
import Combine

import DesignSystem
import Shared
import Resource

import SnapKit
import Then

final class PartnershipViewController: UIViewController {
    
    // MARK: - Properties
    
    private let partnershipViewModel: PartnershipViewModel
    weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "파트너십 혜택")
    
    // MARK: - Init
    
    init(
        partnershipViewModel: PartnershipViewModel,
        coordinator: HomeCoordinator
    ) {
        self.partnershipViewModel = partnershipViewModel
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
    }
}

// MARK: - Private Extensions

private extension PartnershipViewController {
    func setupStyle() {
        view.backgroundColor = .white
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupHierarchy() {
        // SwiftUI 뷰를 UIHostingController로 추가
        let hostingController = UIHostingController(
            rootView: PartnershipView(
                viewModel: partnershipViewModel,
                onBackButtonTapped: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                },
                onImageTapped: { [weak self] index in
                    guard let self else { return }
                    
                    partnershipViewModel.tappendImageSection(index: index)
                    self.coordinator?.showPreviewImage(vm: self.partnershipViewModel)
                }
            )
        )
        addChild(hostingController)
        
        view.addSubviews(customNavBar, hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        if let hostingView = view.subviews.last {
            hostingView.snp.makeConstraints {
                $0.top.equalTo(customNavBar.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
}
