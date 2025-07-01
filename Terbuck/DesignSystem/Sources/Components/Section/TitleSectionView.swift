//
//  TitleSectionView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

public struct TitleSectionView<T: TitleSectionDisplayable>: View {
    
    // MARK: - Properties
    
    let type: SectionType
    let model: T
    
    // MARK: - Init
    
    public init(
        type: SectionType,
        model: TitleSectionDisplayable
    ) {
        self.type = type
        self.model = model as! T
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 5) {
            Text(model.titleText)
                .font(DesignSystem.Font.swiftUIFont(.titleBold20))
                .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                .lineLimit(1)
            
            Text(model.subtitleText)
                .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack10))
                .lineLimit(1)
        }
        .padding(.vertical, 25)
    }
}
