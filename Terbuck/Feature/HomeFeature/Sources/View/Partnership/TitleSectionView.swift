//
//  TitleSectionView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

import DesignSystem

struct TitleSectionView: View {
    
    // MARK: - Properties
    
    let model: DetailPartnershipModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 5) {
            Text(model.partnershipName)
                .font(DesignSystem.Font.swiftUIFont(.titleBold24))
                .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                .lineLimit(1)
            
            Text(model.partnerCategoryType.title)
                .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack10))
                .lineLimit(1)
        }
        .padding(.vertical, 25)
    }
}
