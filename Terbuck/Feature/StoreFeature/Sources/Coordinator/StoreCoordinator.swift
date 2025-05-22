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

public class StoreCoordinator: StoreCoordinating {
    public var childCoordinators: [any Shared.Coordinator] = []
    
    private let navigationController: UINavigationController
    private let storeMapFactory: StoreMapFactory
    private let storeModalFactory: StoreModalFactory
    private let detailStoreFactory: DetailStoreFactory
    private let searchStoreFactory: SearchStoreFactory
    
    private var storeMapViewModel = StoreMapViewModel()
    
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
    
    public func presentStoreModal() {
//        let modalVC = storeModalFactory.makeStoreModalViewController(storeMapViewModel: storeMapViewModel, coordinator: self)
//        
//        modalVC.modalPresentationStyle = .pageSheet // 또는 .automatic
//
//        if let sheet = modalVC.sheetPresentationController {
//            let screenHeight = UIScreen.main.bounds.height
//            
//            sheet.detents = [
//                .custom { _ in 120 },
//                .medium(),
//                .custom(identifier: .init("customDetent")) { _ in
//                            return screenHeight - 168
//                        }
//            ]
//            
//            sheet.largestUndimmedDetentIdentifier = .init("customDetent")
//            sheet.prefersGrabberVisible = true
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            
//            // 여기가 핵심! 특정 Detent까진 어둡지 않게
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
//        
////        if let sheet = modalVC.sheetPresentationController {
////            sheet.detents = [
////                .custom { _ in 40 }, // 작음
////                .medium(),            // 중간
////                .large()              // 큼
////            ]
////            
////            sheet.prefersGrabberVisible = true
////            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
////            sheet.largestUndimmedDetentIdentifier = .none // 배경 어둡게 처리 조정
////        }
////        
////        // 모달 고정
//        modalVC.isModalInPresentation = true
////        modalVC.modalPresentationStyle = .overFullScreen
//        navigationController.present(modalVC, animated: true)
    }
    
    public func showDetailStoreInfo() {
        let detailStoreVC = detailStoreFactory.makeDetailStoreViewController(coordinator: self)
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
