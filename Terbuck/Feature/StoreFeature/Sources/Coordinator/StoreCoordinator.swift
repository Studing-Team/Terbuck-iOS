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
import RegisterStudentCardInterface

public class StoreCoordinator: StoreCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let storeMapFactory: StoreMapFactory
    private let storeModalFactory: StoreModalFactory
    private let detailStoreFactory: DetailStoreFactory
    private let searchStoreFactory: SearchStoreFactory
    private let registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    
    private var storeMapViewModel = StoreMapViewModel(searchStoreMapUseCase: SearchStoreMapUseCaseImpl(repository: StoreRepositoryImpl()))
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        storeMapFactory: StoreMapFactory,
        storeModalFactory: StoreModalFactory,
        detailStoreFactory: DetailStoreFactory,
        searchStoreFactory: SearchStoreFactory,
        registerStudentCardFactory: RegisterStudentCardCoordinatorFactory
    ) {
        self.navigationController = navigationController
        self.storeMapFactory = storeMapFactory
        self.storeModalFactory = storeModalFactory
        self.detailStoreFactory = detailStoreFactory
        self.searchStoreFactory = searchStoreFactory
        self.registerStudentCardFactory = registerStudentCardFactory
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
    
    public func startRegisterStudentCard(for type: AuthStudentType, location: CGRect?) {
        let registerCoordinator = registerStudentCardFactory.makeRegisterStudentCardCoordinator(
            navigationController: self.navigationController,
            initialType: type,
            initialLocation: location
        )

        registerCoordinator.delegate = self
        
        childCoordinators.append(registerCoordinator)
        
        registerCoordinator.start()
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

// MARK: - 학생증 재등록을 위한 Coordinator

extension StoreCoordinator: RegisterStudentCardCoordinatorDelegate {
    public func didFinishRegisterStudentCard(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
