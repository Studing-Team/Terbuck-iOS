//
//  StoreBottomSheetDelegate.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/22/25.
//

import Foundation

// 바텀 시트 델리게이트 프로토콜
protocol StoreBottomSheetDelegate: AnyObject {
    func bottomSheet(_ bottomSheet: StoreListModalViewController, currentPoint: CGFloat, didChangeHeight: CGFloat)
}
