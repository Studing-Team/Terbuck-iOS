//
//  StoreMapViewController.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import UIKit
import Combine
import CoreLocation

import DesignSystem
import Shared

import SnapKit
import Then
import NMapsMap

public final class StoreMapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let storeMapViewModel: StoreMapViewModel
    weak var coordinator: StoreCoordinator?
    private let locationManager = CLLocationManager()
    private var bottomSheetTopConstraint: NSLayoutConstraint?
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    
    private let mapView = NMFMapView()
    private var currentLocationMarker: NMFMarker?
    private var bottomSheetVC: StoreListModalViewController
    
    
    private let searchBarView = SearchBarView()
    private let myLocationButton = UIButton()
    
    // MARK: - Init
    
    public init(
        storeMapViewModel: StoreMapViewModel,
        coordinator: StoreCoordinator
    ) {
        self.storeMapViewModel = storeMapViewModel
        self.coordinator = coordinator
        self.bottomSheetVC = StoreListModalViewController(
            storeMapViewModel: storeMapViewModel,
            coordinator: coordinator,
            type: .verticalList
        )
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
        setupLocationManager()
        setupPresentModal()
        bindViewModel()
        
        viewLifeCycleSubject.send(.viewDidLoad)
    }
}

// MARK: - Private Bind Extensions

private extension StoreMapViewController {
    func bindViewModel() {
        let input = StoreMapViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher()
        )
        
        let output = storeMapViewModel.transform(input: input)
        
        output.storeListData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                // TODO: - 지도에 마커 업데이트
                items.forEach {
                    self?.updateMapMarkers($0)
                }
            }
            .store(in: &cancellables)
        
        output.didSelectItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemId in
                self?.coordinator?.showDetailStoreInfo()
            }
            .store(in: &cancellables)
        
        output.markerPinTappedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemId in
                self?.bottomSheetVC.changeBottomSheet(.horizonList)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension StoreMapViewController {
    func setupStyle() {
        navigationItem.backButtonTitle = ""

        [searchBarView, myLocationButton].forEach {
            $0.do {
                $0.layer.cornerRadius = 16
                $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
                $0.layer.shadowOffset = CGSize(width: 3, height: 3)  // 그림자 위치
                $0.layer.shadowOpacity = 0.3  // 그림자 투명도
                $0.layer.shadowRadius = 5 // 그림자 퍼짐 정도
            }
        }
        
        myLocationButton.do {
            $0.setImage(.myLocation, for: .normal)
            $0.setImage(.myLocation.withTintColor(DesignSystem.Color.uiColor(.terbuckGreen50)), for: .selected)
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
            $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        }
        
        searchBarView.do {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(mapView, searchBarView, myLocationButton)
    }
    
    func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(48)
        }
        
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            $0.leading.equalTo(searchBarView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(48)
        }
    }
    
    func setupDelegate() {
        bottomSheetVC.delegate = self
        mapView.touchDelegate = self
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupPresentModal() {
        // 자식 뷰 컨트롤러 추가
        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        let initialSnapPoint = bottomSheetVC.initialSnapPoint
        
        print("기존 설정 높이", initialSnapPoint)
        print("바텀 높이", bottomSheetVC.view.frame.height)
        
        // 기본 제약 조건 설정 (화면 하단에 맞춤)
        bottomSheetVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSheetTopConstraint = bottomSheetVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height - 46 - initialSnapPoint)
        
        NSLayoutConstraint.activate([
            bottomSheetVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetTopConstraint!
        ])
    }
    
    @objc func myLocationButtonTapped() {
        myLocationButton.isSelected.toggle()
        // 위치 권한 확인
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            // 권한 없음 알림
//            showLocationPermissionAlert()
            break
        }
    }
    
    @objc func searchBarTapped() {
        self.coordinator?.searchStore()
    }
}

extension StoreMapViewController: NMFMapViewCameraDelegate {
    func selectCategoryTypeImage(_ type: CategoryType) -> UIImage {
        switch type {
        case .all:
            return UIImage()
        case .bar:
            return .barMarkerPin
        case .cafe:
            return .cafeMarkerPin
        case .culture:
            return .cultureMarkerPin
        case .gym:
            return .gymMarkerPin
        case .hospital:
            return .hospitalMarkerPin
        case .restaurant:
            return .restaurantMarkerPin
        case .study:
            return .studyMarkerPin
        }
    }
    
    func updateMapMarkers(_ items: StoreListModel) {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(image: selectCategoryTypeImage(items.category))
        marker.width = 34
        marker.height = 42
        marker.userInfo = ["store": items]
        let storeLocation = NMGLatLng(lat: items.latitude, lng: items.longitude)
        marker.position = storeLocation
        
        marker.mapView = mapView
        
        marker.touchHandler = { [weak self] (overlay) -> Bool in
            if let store = overlay.userInfo["store"] as? StoreListModel {
                print("마커가 눌린 가게: \(store.storeName)")
                self?.moveCameraToMarker(NMGLatLng(lat: store.latitude, lng: store.longitude))
                self?.storeMapViewModel.markerTappedSubject.send(store)
            }
            return true
        }
    }
    
    func moveCameraToMarker(_ position: NMGLatLng) {
        let centeredPosition = NMGLatLng(lat: position.lat, lng: position.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: centeredPosition)
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
    }
    
    private func updateMapToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        // 현재 위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        
        // 마커 업데이트
        if currentLocationMarker == nil {
            currentLocationMarker = NMFMarker()
        }
        
        currentLocationMarker?.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        currentLocationMarker?.mapView = mapView
    }
}

// MARK: - CLLocationManagerDelegate
    
extension StoreMapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateMapToCurrentLocation(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

extension StoreMapViewController: NMFMapViewTouchDelegate {
    public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.bottomSheetVC.changeBottomSheet(.verticalList)
    }
}

// MARK: - StoreBottomSheetDelegate

extension StoreMapViewController: StoreBottomSheetDelegate {
    func bottomSheet(_ bottomSheet: StoreListModalViewController, currentPoint: CGFloat, didChangeHeight: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let bottomSheetTopConstraint = self.bottomSheetTopConstraint else {
                print("BottomSheetTopConstraint is nil or self is deallocated")
                return
            }
            
            let newTopConstant = self.view.frame.height - currentPoint - didChangeHeight
            

            bottomSheetTopConstraint.constant = newTopConstant
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
                print("Animated bottomSheet view top constant: \(newTopConstant)\n")
            }, completion: { _ in
                
                print("바텀 애니메이션 완료", currentPoint)

            })
        }
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("StoreMapViewController") {
//    StoreMapViewController()
//        .showPreview()
//}
//#endif
