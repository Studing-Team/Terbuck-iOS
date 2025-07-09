//
//  SplashFactoryImpl.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 6/11/25.
//

import UIKit
import SplashInterface

public final class SplashFactoryImpl: SplashFactory {
    
    public init() {}
    
    public func makeSplashCoordinator(window: UIWindow) -> SplashCoordinating {
        return SplashCoordinator(window: window)
    }
}
