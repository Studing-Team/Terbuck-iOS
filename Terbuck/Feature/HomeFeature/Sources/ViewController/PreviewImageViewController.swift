//
//  PreviewImageViewController.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import UIKit
import SwiftUI
import Combine

import DesignSystem
import Shared
import Resource

import SnapKit
import Then

final class PreviewImageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let partnershipViewModel: PartnershipViewModel
    weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Properties
    
    private let customNavBar: CustomNavigationView
    
    // MARK: - Init
    
    init(
        partnershipViewModel: PartnershipViewModel,
        coordinator: HomeCoordinator
    ) {
        self.partnershipViewModel = partnershipViewModel
        self.coordinator = coordinator
        self.customNavBar = CustomNavigationView(type: .previewImage, title: partnershipViewModel.selectImageData?.title ?? "")
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

private extension PreviewImageViewController {
    func setupStyle() {
        view.backgroundColor = .black
        customNavBar.setupBackButtonAction { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    func setupHierarchy() {
        let hostingController = UIHostingController(
            rootView: PreviewImageView(
                viewModel: partnershipViewModel
            )
        )
        addChild(hostingController)
        hostingController.view.backgroundColor = .black
        
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
