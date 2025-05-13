//
//  ContentSectionView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

import DesignSystem

struct ContentSectionView: View {
    
    // MARK: - Properties
    
    let model: DetailPartnerBenefitModel
    
    // MARK: - Body
    
    var body: some View {
        Text(model.content)
            .font(DesignSystem.Font.swiftUIFont(.textRegular14))
            .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
            .lineSpacing(3)
            .frame(minWidth: 311)
            .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
            .background(DesignSystem.Color.swiftUIColor(.terbuckWhite3))
            .clipShape(.rect(cornerRadius: 8.0))
    }
}
