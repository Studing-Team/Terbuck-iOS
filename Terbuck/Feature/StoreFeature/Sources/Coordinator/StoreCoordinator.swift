//
//  StoreCoordinator.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/13/25.
//

import UIKit

import StoreInterface
import DesignSystem
import Shared
import RegisterStudentCardFeature

public class StoreCoordinator: StoreCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let storeMapFactory: StoreMapFactory
    private let storeModalFactory: StoreModalFactory
    private let detailStoreFactory: DetailStoreFactory
    private let searchStoreFactory: SearchStoreFactory
    
    private var storeMapViewModel = StoreMapViewModel(searchStoreMapUseCase: SearchStoreMapUseCaseImpl(repository: StoreRepositoryImpl()))
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        storeMapFactory: StoreMapFactory,
        storeModalFactory: StoreModalFactory,
        detailStoreFactory: DetailStoreFactory,
        searchStoreFactory: SearchStoreFactory
    ) {
        self.navigationController = navigationController
        self.storeMapFactory = storeMapFactory
        self.storeModalFactory = storeModalFactory
        self.detailStoreFactory = detailStoreFactory
        self.searchStoreFactory = searchStoreFactory
    }
    
    // MARK: - Method
    
    public func start() {
        startStoreMap()
    }
    
    public func startStoreMap() {
        let storeMapVC = storeMapFactory.makeStoreMapViewController(storeMapViewModel: storeMapViewModel, coordinator: self)
        navigationController.pushViewController(storeMapVC, animated: true)
    }
    
    public func showDetailStoreInfo(storeId: Int) {
        let detailStoreVC = detailStoreFactory.makeDetailStoreViewController(coordinator: self, storeId: storeId)
        detailStoreVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailStoreVC, animated: true)
    }
    
    public func searchStore() {
        let searchStoreVC = searchStoreFactory.makeSearchStoreViewController(storeMapViewModel: storeMapViewModel, coordinator: self)
        searchStoreVC.modalPresentationStyle = .overFullScreen
        searchStoreVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(searchStoreVC, animated: false)
    }
}

extension StoreCoordinator: StudentIDCardFlowDelegate {
    public func showOnboardiing(location: CGRect) {
        
    }
    
    public func registerStudentID() {
        let viewModel = RegisterStudentCardViewModel(
            registerStudentIDUseCase: RegisterStudentIDUseCaseImpl(repository: RegisterRepositoryImpl())
        )
        
        let registerStudentIDCardVC = RegisterStudentCardViewController(viewModel: viewModel)
        registerStudentIDCardVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(registerStudentIDCardVC, animated: true)
    }
    
    public func dismissAuthStudentID() {
        navigationController.dismiss(animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.registerStudentID()
            }
        }
    }
    
    public func showAuthStudentID() {
        let studentIdCardVC = StudentIDCardViewController(
            authType: .auth,
            coordinator: self,
            viewModel: StudentIdCardViewModel()
        )
        
        studentIdCardVC.modalPresentationStyle = .overFullScreen
        navigationController.present(studentIdCardVC, animated: false)
    }
}


extension StoreCoordinator: ImagePreviewCoordinating {
    public func showPreviewImage(vm: PreviewImageDisplayable) {
        let previewImageVC = PreviewImageViewController(
            viewModel: vm,
            coordinator: self
        )
        previewImageVC.modalPresentationStyle = .overFullScreen
        navigationController.present(previewImageVC, animated: false)
    }
}
