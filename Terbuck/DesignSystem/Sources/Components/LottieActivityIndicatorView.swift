//
//  LottieActivityIndicatorView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 10/17/25.
//

import UIKit

import Shared
import Resource

import SnapKit
import Then
import Lottie

public final class LottieActivityIndicatorView: UIView {
    
    // MARK: - Properties
    
    private var activityIndicatorHidden = true {
        didSet {
            setupHidden()
        }
    }
    
    // MARK: - UI Properties
    
    private let indicatorBackground = UIView()
    private let activityIndicator = LottieAnimationView(name: "LoadingIndicator", bundle: ResourceResources.bundle)
    
    // MARK: - Init

    public init(isHidden: Bool = true) {
        self.activityIndicatorHidden = isHidden
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupHidden()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppLogger.log("LottieActivityIndicatorView Deinit", .info, .ui)
    }
}

// MARK: - Public func Extensions

public extension LottieActivityIndicatorView {
    func setAnimating(_ animating: Bool) {
        isHidden = !animating
        self.activityIndicatorHidden = !animating
        
        if animating {
            activityIndicator.play()
        } else {
            activityIndicator.stop()
        }
    }
}

// MARK: - Private Extensions

private extension LottieActivityIndicatorView {
    func setupStyle() {
        indicatorBackground.do {
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckIndicatorBackground)
        }
        
        activityIndicator.do {
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFit
            $0.animationSpeed = 1.0
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(indicatorBackground)
        indicatorBackground.addSubviews(activityIndicator)
    }
    
    func setupLayout() {
        indicatorBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(self.convertByHeightRatio(200))
        }
    }
    
    func setupHidden() {
        indicatorBackground.isHidden = activityIndicatorHidden
        activityIndicator.isHidden = activityIndicatorHidden
    }
}

private extension LottieActivityIndicatorView {
    func indicatorHidden(_ isHidden: Bool) {
        self.activityIndicatorHidden = isHidden
    }
    
    func playIndicator() {
        activityIndicator.play()
    }
    
    func stopIndicator() {
        activityIndicator.stop()
    }
}

// MARK: - Show Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("LottieActivityIndicatorView") {
    LottieActivityIndicatorView()
        .showPreview()
}
#endif
