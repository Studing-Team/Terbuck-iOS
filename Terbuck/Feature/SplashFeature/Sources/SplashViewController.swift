//
//  SplashViewController.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import UIKit
import Combine

import CoreNetwork
import DesignSystem
import Shared

import SnapKit
import Then

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private var shouldShowLogin: Bool?
    weak var delegate: SplashViewControllerDelegate?
    
    private var viewModel: SplashViewModel
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let logoImageView = UIImageView()
    
    // MARK: - Init
    
    public init(
        viewModel: SplashViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppLogger.log("SplashViewController Deinit", .info, .ui)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        viewLifeCycleSubject.send(.viewDidLoad)
    }
}

// MARK: - Private Bind Extensions

private extension SplashViewController {
    func bindViewModel() {
        let input = SplashViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.splashAction
            .receive(on: DispatchQueue.main)
            .delay(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .goToMain:
                    self?.delegate?.splashDidFinish(shouldShowLogin: false)
                case .goToLogin:
                    self?.delegate?.splashDidFinish(shouldShowLogin: true)
                case .needsUpdate:
                    self?.showConfirmAlert(
                        mainTitle: "업데이트가 필요해요",
                        subTitle: "새로운 기능과 더 나은 사용을 위해\n앱을 최신 버전으로 바꿔주세요",
                        centerButton: TerbuckBottomButton(type: .update),
                        centerButtonHandler: {
                            self?.openAppStore()
                        }
                    )
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension SplashViewController {
    func setupStyle() {
        self.view.backgroundColor = .white
        
        logoImageView.do {
            $0.image = UIImage.terbuckLogo
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(logoImageView)
    }
    
    func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(130)
        }
    }
    
    func setupDelegate() {
        
    }
    
    func openAppStore() {
        guard let appID = Bundle.main.infoDictionary?["APP_ID"] as? String else {
            AppLogger.log("Error: App ID not found in Info.plist", .error, .ui)
            return
        }
        
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id/\(appID)") else {
            AppLogger.log("Error: Invalid App Store URL", .error, .ui)
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("SplashViewController") {
//    SplashViewController()
//        .showPreview()
//}
//#endif
