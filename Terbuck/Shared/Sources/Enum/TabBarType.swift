//
//  TabBarType.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/24/25.
//

import UIKit
import Resource

public enum TabBarType: Int, CaseIterable {
    case home = 0
    case store = 1
    case mypage = 2
    
    public var title: String {
        switch self {
        case .home:
            return "홈"
        case .store:
            return "터벅터벅"
        case .mypage:
            return "마이"
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .home: return ResourceAsset.Image.home.image.withRenderingMode(.alwaysOriginal)
        case .store: return ResourceAsset.Image.store.image.withRenderingMode(.alwaysOriginal)
        case .mypage: return ResourceAsset.Image.mypage.image.withRenderingMode(.alwaysOriginal)
        }
    }

    public var selectedImage: UIImage? {
        switch self {
        case .home: return ResourceAsset.Image.selectHome.image.withRenderingMode(.alwaysOriginal)
        case .store: return ResourceAsset.Image.selectStore.image.withRenderingMode(.alwaysOriginal)
        case .mypage: return ResourceAsset.Image.selectMypage.image.withRenderingMode(.alwaysOriginal)
        }
    }
}
