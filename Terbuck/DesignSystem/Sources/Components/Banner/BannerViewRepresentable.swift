//
//  BannerViewRepresentable.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 12/21/25.
//

import SwiftUI
import GoogleMobileAds
import Shared
import UIKit

public struct BannerViewRepresentable: UIViewRepresentable {
    
    // MARK: - Property
    
    let adUnitID: String = Config.googleAdmobUnitKey
    let bannerWidth: CGFloat
    @Binding var adHeight: CGFloat
    
    // MARK: - Init
    
    public init(bannerWidth: CGFloat, adHeight: Binding<CGFloat>) {
        self.bannerWidth = bannerWidth
        self._adHeight = adHeight
    }
    
    // MARK: - Context Coordinator
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(adHeight: $adHeight)
    }
    
    public class Coordinator: NSObject, GADBannerViewDelegate {
        @Binding var adHeight: CGFloat

        init(adHeight: Binding<CGFloat>) {
            self._adHeight = adHeight
        }
        
        public func bannerViewAdSizeDidChange(_ bannerView: GADBannerView) {
            let newAdHeight = bannerView.adSize.size.height
            print("📣 GADBannerViewDelegate: bannerViewAdSizeDidChange - New ad height: \(newAdHeight)")
            adHeight = newAdHeight
        }
        
        public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ GADBannerViewDelegate: bannerView - Ad failed to receive with error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - func

    public func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth))
        bannerView.adUnitID = adUnitID
        
        // Find the top-most view controller and set it as rootViewController
        guard let root = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return GADBannerView() }
        guard var topController = root.windows.first?.rootViewController else { return GADBannerView() }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        bannerView.rootViewController = topController
        
        bannerView.delegate = context.coordinator // Set the delegate
        bannerView.load(GADRequest())
        
        // Immediately update adHeight with the calculated adaptive banner height
        DispatchQueue.main.async {
            print("adHeight:", adHeight)
            adHeight = bannerView.adSize.size.height
            print("새로운 값:", bannerView.adSize.size.height)
        }
        
        return bannerView
    }

    public func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
