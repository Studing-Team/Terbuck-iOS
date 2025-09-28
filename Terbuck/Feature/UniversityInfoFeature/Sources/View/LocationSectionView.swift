//
//  LocationSectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import SwiftUI

import DesignSystem

struct LocationSectionView: View {
    
    let section: [String]
    let onItemSelected: (String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(section.enumerated()), id: \.offset) { index, item in
                    Button(action: {
                        onItemSelected(item)
                    }) {
                        HStack(spacing: 0) {
                            Text(item)
                                .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                                .foregroundStyle(DesignSystem.Color.swiftUIColorToDarken(.terbuckBlack30, darkenValue: 0.2))
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical, 13)
                    .padding(.horizontal, 16)
                    .background(DesignSystem.Color.swiftUIColor(.terbuckWhite3))
                    .cornerRadius(6)
                }
            }
        }
        .scrollIndicators(.never)
    }
}

//#Preview {
//    AccordionView(isExpanded: true)
//}
