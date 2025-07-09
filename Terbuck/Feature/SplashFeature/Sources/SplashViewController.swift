//
//  SplashViewController.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import UIKit

import CoreNetwork
import CoreKeyChain
import DesignSystem
import Shared

import SnapKit
import Then

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private var shouldShowLogin: Bool?
    weak var delegate: SplashViewControllerDelegate?
    
    // MARK: - UI Properties
    
    private let logoImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        
        Task {
            if let token = KeychainManager.shared.load(key: .accessToken) {
                await searchMyInfo()
            } else {
                self.shouldShowLogin = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let shouldShowLogin = self.shouldShowLogin else { return }
            self.delegate?.splashDidFinish(shouldShowLogin: shouldShowLogin)
        }
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
}

private extension SplashViewController {
    func searchMyInfo() async {
        do {
            let dto: SearchStudentInfoResponseDTO = try await NetworkManager.shared.request(MemberAPIEndpoint.getStudentId)
            
            UserDefaultsManager.shared.set(dto.isRegistered, for: .isStudentIDAuthenticated)
            UserDefaultsManager.shared.set(dto.university, for: .university)
            
            if let imageURL = dto.imageURL {
                UserDefaultsManager.shared.set(imageURL, for: .studentIdCardImageURL)
            }
            
            self.shouldShowLogin = false
        } catch {
            self.shouldShowLogin = true
        }
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("SplashViewController") {
    SplashViewController()
        .showPreview()
}
#endif
