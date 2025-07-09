//
//  LoginViewController.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/10/25.
//

import UIKit
import Combine
import CoreLocation

import DesignSystem
import Shared

import SnapKit
import Then

public final class LoginViewController: UIViewController {
    
    // MARK: - Combine Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    
    // MARK: - UI Properties
    
    private let terbuckTitleLabel = UILabel()
    private let terbuckLogoLabel = TerbuckLogoLabel(type: .max)
    private let appleLoginButton = SocialLoginButton(type: .apple)
    private let kakaoLoginButton = SocialLoginButton(type: .kakao)
    
    // MARK: - Init
    
    init(
        viewModel: LoginViewModel,
        coordinator: AuthCoordinator
    ) {
        self.viewModel = viewModel
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
        bindViewModel()
        
        requestLocation()
        requestNotificationPermission()
    }
}

// MARK: - Private Bind Extensions

private extension LoginViewController {
    func bindViewModel() {
        let input = LoginViewModel.Input(
            appleLoginButtonTapped: appleLoginButton.tapPublisher,
            kakaoLoginButtonTapped: kakaoLoginButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case .appleLoginFailed:
                            break
                        case .kakaoLoginFailed:
                            break
                        case .serverLoginFailed:
                            break
                        case .unknown:
                            self?.showConfirmAlert(
                                mainTitle: error.errorDescription,
                                subTitle: "잠시 후, 다시 시도해주세요.",
                                centerButton: TerbuckBottomButton(type: .confirm),
                                centerButtonHandler: {}
                            )
                        case .saveFcmTokenFailed:
                            break
                        }
                    }
                },
                receiveValue: { [weak self] showSignup in
                    if showSignup {
                        self?.coordinator?.startTermsOfService()
                    } else {
                        self?.coordinator?.finishAuthFlow()
                    }
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension LoginViewController {
    func setupStyle() {
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        
        terbuckTitleLabel.do {
            $0.text = "한 걸음마다 있는 우리 학교 제휴 혜택"
            $0.font = DesignSystem.Font.uiFont(.textRegular16)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckDarkGray50)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(terbuckTitleLabel, terbuckLogoLabel, kakaoLoginButton, appleLoginButton)
    }
    
    func setupLayout() {
        terbuckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(194))
            $0.horizontalEdges.equalToSuperview().inset(71)
        }
        
        terbuckLogoLabel.snp.makeConstraints {
            $0.top.equalTo(terbuckTitleLabel.snp.bottom).offset(view.convertByHeightRatio(6))
            $0.horizontalEdges.equalToSuperview().inset(70)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(terbuckLogoLabel.snp.bottom).offset(view.convertByHeightRatio(190))
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(view.convertByHeightRatio(12))
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
        }
    }
    
    func requestLocation() {
        switch self.locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("❌ 위치 권한 거부됨 - 설정에서 권한 변경 필요")
        default:
            break
        }
    }
    
    func setupDelegate() {
        
    }
    
    // MARK: - 원격 알림 권한 요청
    
    func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

//// MARK: - Show Preview
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("LoginViewController") {
//    LoginViewController()
//        .showPreview()
//}
//#endif
