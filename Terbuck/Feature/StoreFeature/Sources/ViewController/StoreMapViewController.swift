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

final class StoreMapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let storeMapViewModel: StoreMapViewModel
    weak var coordinator: StoreCoordinator?
    private let locationManager = CLLocationManager()
    private var bottomSheetTopConstraint: NSLayoutConstraint?
    private var isFindMyLocation: Bool = false
    
    // MARK: - Marker Properties
    
    private var allMarkersDic: [CategoryType: [NMFMarker]] = [:]
    private var currentCategoryMarkers: [NMFMarker] = []
    private var selectedMarker: NMFMarker? {
        didSet {
            changeMarkerImage()
        }
    }
    
    // MARK: - Combine Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let mapView = NMFMapView()
    private var currentLocationMarker: NMFMarker?
    private var bottomSheetVC: StoreListModalViewController
    private var searchStoreVC: SearchStoreViewController?
    
    private let searchBarView = SearchBarView(type: .search)
    private let storeInfoBottomView = StoreInfoBottomView()
    private let myLocationButton = UIButton()
    
    // MARK: - Init
    
    init(
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupPresentModal()
        bindViewModel()
        
        setupLocationManager()
        requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppLogger.log("StoreMapViewController viewWillAppear", .info, .ui)
        
        storeMapViewModel.viewLifeCycleSubject.send(.viewWillAppear)
        
        switch storeMapViewModel.storeMapTypeSubject.value {
        case .search:
            tabBarController?.tabBar.isHidden = false
            searchBarView.configureSearchType(.search)
        case .searchResult:
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - Private Bind Extensions

private extension StoreMapViewController {
    func bindViewModel() {
        storeMapViewModel.storeListSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self else { return }
                
                let index = storeMapViewModel.storeCategoryPublisher.value
                let type = CategoryType.allCases[index]
                
                self.initStoreMarkers(with: items)
                self.filterToCategoryTypeMarker(category: type)
                self.fitAllMarkers(currentCategoryMarkers, in: mapView, currentIndex: self.storeMapViewModel.currentSnapIndex.value)
            }
            .store(in: &cancellables)
        
        storeMapViewModel.markerTappedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tappedStore in
                guard let self else { return }
                self.searchBarView.configureSearchType(.search)
                self.storeInfoBottomView.configureData(forModel: tappedStore)
                self.updateSearchLayout(tappedStore, isHidden: false)
            }
            .store(in: &cancellables)
        
        storeMapViewModel.storeItemsTappedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemId in
                MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.storelistDataTapped)
                self?.coordinator?.showDetailStoreInfo(storeId: itemId)
            }
            .store(in: &cancellables)
        
        storeMapViewModel.currentSnapIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                fitAllMarkers(currentCategoryMarkers, in: mapView, currentIndex: index)
            }
            .store(in: &cancellables)
        
        storeMapViewModel.storeMapTypeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                guard let self else { return }
                
                bottomSheetVC.view.isHidden = type == .search ? false : true
                tabBarController?.tabBar.isHidden = type == .search ? false : true
                storeInfoBottomView.isHidden = type == .searchResult ? false : true
                
                if type == .search {
                    searchBarView.configureSearchType(.search)
                    let index = storeMapViewModel.storeCategoryPublisher.value
                    let type = CategoryType.allCases[index]
                    filterToCategoryTypeMarker(category: type)
                    self.fitAllMarkers(currentCategoryMarkers, in: mapView, currentIndex: self.storeMapViewModel.currentSnapIndex.value)
                }
            }
            .store(in: &cancellables)
        
        storeMapViewModel.searchListStoreTappedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchStore in
                self?.storeInfoBottomView.configureData(forModel: searchStore)
                self?.searchBarView.configureSearchResultType(storeName: searchStore.storeName)
                self?.makeSingleMarker(store: searchStore)
                self?.updateSearchLayout(searchStore, isHidden: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Marker Extensions

private extension StoreMapViewController {
    func initStoreMarkers(with items: [StoreListModel]) {
        removeCurrentMarkersInMapView()
        allMarkersDic.removeAll()

        items.forEach {
            let marker = NMFMarker()
            marker.iconImage = NMFOverlayImage(image: selectCategoryTypeImage($0.category))
            marker.width = 34
            marker.height = 42
            marker.userInfo = ["store": $0]
            marker.position = NMGLatLng(lat: $0.latitude, lng: $0.longitude)
            marker.mapView = mapView

            marker.touchHandler = { [weak self] (overlay) -> Bool in
                if let store = overlay.userInfo["store"] as? StoreListModel,
                   let tappedMarker = overlay as? NMFMarker {
                    if self?.storeMapViewModel.storeMapTypeSubject.value == .search {
                        self?.moveCameraToMarker(NMGLatLng(lat: store.latitude, lng: store.longitude))
                        self?.storeMapViewModel.markerTappedSubject.send(store)
                        self?.changeMarkerSize(tappedMarker: tappedMarker)
                        self?.selectedMarker = tappedMarker
                        
                        MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.mapMarkerButtonTapped)
                    }
                }
                
                return true
            }
            
            allMarkersDic[$0.category, default: []].append(marker)
            currentCategoryMarkers.append(marker)
        }
    }
    
    func removeCurrentMarkersInMapView() {
        currentCategoryMarkers.forEach {
            $0.mapView = nil
        }
        
        currentCategoryMarkers = []
    }
    
    /// 지도에 표기할 마커를 통해 mapView 에 할당하는 메서드
    func makeMakerInMapView() {
        currentCategoryMarkers.forEach {
            $0.mapView = mapView
        }
    }
    
    func filterToCategoryTypeMarker(category: CategoryType) {
        removeCurrentMarkersInMapView()
        
        if category == .all {
            allMarkersDic.forEach { category, markers in
                currentCategoryMarkers += markers
            }
        } else {
            guard let categoryMarkers = allMarkersDic[category] else {
                currentCategoryMarkers = []
                return
            }

            currentCategoryMarkers = categoryMarkers
        }

        makeMakerInMapView()
    }
    
    func makeSingleMarker(store: StoreListModel) {
        selectedMarker = nil
        removeCurrentMarkersInMapView()
        
        guard let categoryMarkers = allMarkersDic[store.category] else { return }
        
        let storeMarker = categoryMarkers.first { marker in
            guard let storedStore = marker.userInfo["store"] as? StoreListModel else { return false }
            return storedStore.id == store.id
        }
        
        storeMarker?.mapView = mapView
    }

    func fitAllMarkers(_ markers: [NMFMarker], in mapView: NMFMapView, currentIndex: Int) {
        guard !markers.isEmpty else { return }

        let height = [180, 290, 454, 700]
        // 1. 모든 마커 좌표를 가져옴
        let latLngs: [NMGLatLng] = markers.map { $0.position }
        let bounds = NMGLatLngBounds(latLngs: latLngs)

        // 2. 카메라 업데이트로 이동 (padding 포함)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: UIEdgeInsets(
            top: 220, left: 30, bottom: CGFloat(height[currentIndex] + 50), right: 30)
        )
        
        cameraUpdate.animation = .linear
        cameraUpdate.animationDuration = 0.3
        mapView.moveCamera(cameraUpdate)
    }
    
    func changeMarkerSize(tappedMarker: NMFMarker) {
        // 이전 마커 복원
        if let previousMarker = self.selectedMarker, previousMarker != tappedMarker {
            previousMarker.width = 34
            previousMarker.height = 42

        }
        
        // 현재 마커 확대
        tappedMarker.width = 48
        tappedMarker.height = 60
    }
    
    func changeMarkerImage() {
        currentCategoryMarkers.forEach {
            if selectedMarker != nil && selectedMarker != $0 {
                if let storeData = $0.userInfo["store"] as? StoreListModel {
                    $0.iconImage = NMFOverlayImage(image: selectCategoryTypeImage(storeData.category, isSelected: false))
                }
            } else {
                if let storeData = $0.userInfo["store"] as? StoreListModel {
                    $0.iconImage = NMFOverlayImage(image: selectCategoryTypeImage(storeData.category))
                }
            }
        }
    }
}

// MARK: - Private Extensions

private extension StoreMapViewController {
    func setupStyle() {
        navigationItem.backButtonTitle = ""

        [searchBarView, myLocationButton, storeInfoBottomView].forEach {
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
        
        storeInfoBottomView.do {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(storeBottomTapped))
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(mapView, searchBarView, myLocationButton, storeInfoBottomView)
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
        
        storeInfoBottomView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(112)
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
        MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.myLocationButtonTapped)
        locationManager.startUpdatingLocation()
        myLocationButton.isSelected.toggle()
        isFindMyLocation = true
        locationManager.stopUpdatingLocation()
    }

    @objc func searchBarTapped() {
        if storeMapViewModel.storeMapTypeSubject.value == .search {
            MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.searchBarTapped)
            self.coordinator?.searchStore()
        } else {
            storeMapViewModel.storeMapTypeSubject.send(.search)
        }
    }
    
    @objc func storeBottomTapped() {
        guard let store = storeMapViewModel.searchResultStoreTappedSubject.value else { return }
        MixpanelManager.shared.track(eventType: TrackEventType.TerbuckMap.storeMapDataTapped)
        self.coordinator?.showDetailStoreInfo(storeId: store.id)
    }
    
    func requestLocation() {
        switch self.locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            AppLogger.log("지도 위치 권한 이미 허용됨. 위치 업데이트 시작.", .info, .service)
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            AppLogger.log("위치 권한이 거부되었거나 제한된 상태", .error, .service)
        default:
            break
        }
    }
    
    func updateSearchLayout(_ store: StoreListModel, isHidden: Bool) {
        bottomSheetVC.view.isHidden = true
        tabBarController?.tabBar.isHidden = isHidden
        
        storeInfoBottomView.snp.remakeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(112)
            if isHidden {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
            } else {
                $0.bottom.equalToSuperview().inset(92)
            }
        }
        
        moveCameraToMarker(NMGLatLng(lat: store.latitude, lng: store.longitude))
        storeMapViewModel.searchResultStoreTappedSubject.send(store)
        
        storeInfoBottomView.isHidden = false
    }
}

extension StoreMapViewController: NMFMapViewCameraDelegate {
    func selectCategoryTypeImage(_ type: CategoryType, isSelected: Bool = true) -> UIImage {
        switch type {
        case .all:
            return UIImage()
        case .bar:
            return isSelected == true ? .barMarkerPin : .notSelectBarMarkerPin
        case .cafe:
            return isSelected == true ? .cafeMarkerPin : .notSelectCafeMarkerPin
        case .culture:
            return isSelected == true ? .cultureMarkerPin : .notSelectCultureMarkerPin
        case .gym:
            return isSelected == true ? .gymMarkerPin : .notSelectGymMarkerPin
        case .hospital:
            return isSelected == true ? .hospitalMarkerPin : .notSelectHospitalMarkerPin
        case .restaurant:
            return isSelected == true ? .restaurantMarkerPin : .notSelectRestaurantMarkerPin
        case .study:
            return isSelected == true ? .studyMarkerPin : .notSelectStudyMarkerPin
        }
    }
    
    func moveCameraToMarker(_ position: NMGLatLng) {
        let centeredPosition = NMGLatLng(lat: position.lat, lng: position.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: centeredPosition)
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
    }
    
    private func updateMapToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude),
            zoom: 15.0
        )
        
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        storeMapViewModel.updateLocationData(lat: coordinate.latitude, lng: coordinate.longitude)
            
        // 마커 업데이트
        if currentLocationMarker == nil {
            currentLocationMarker = NMFMarker()
            currentLocationMarker?.iconImage = NMFOverlayImage(image: UIImage.myDirection)
        }
        
        currentLocationMarker?.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        currentLocationMarker?.mapView = mapView
    }
}

extension StoreMapViewController: NMFMapViewTouchDelegate {
    public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if storeMapViewModel.storeMapTypeSubject.value == .search {
            selectedMarker?.width = 34
            selectedMarker?.height = 42
            self.selectedMarker = nil
            self.bottomSheetVC.view.isHidden = false
            self.storeInfoBottomView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

// MARK: - CLLocationManagerDelegate
    
extension StoreMapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if isFindMyLocation {
            updateMapToCurrentLocation(location.coordinate)
        }
        
        isFindMyLocation = false
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ 위치 업데이트 실패: \(error.localizedDescription)")
    }
}

// MARK: - StoreBottomSheetDelegate

extension StoreMapViewController: StoreBottomSheetDelegate {
    func bottomSheet(_ bottomSheet: StoreListModalViewController, currentPoint: CGFloat, didChangeHeight: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let bottomSheetTopConstraint = self.bottomSheetTopConstraint else {
                return
            }
            
            let newTopConstant = self.view.frame.height - currentPoint - didChangeHeight
            

            bottomSheetTopConstraint.constant = newTopConstant
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
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
