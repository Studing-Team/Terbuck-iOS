//
//  UniversitySectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import SwiftUI
import DesignSystem
import Shared

struct UniversitySectionView: View {
    
    let section: [String]
    let selectedItem: String?
    let onItemSelected: (String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(section, id: \.self) { item in
                    HStack(spacing: 0) {
                        Text(item)
                            .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                            .foregroundStyle(DesignSystem.Color.swiftUIColorToDarken(.terbuckBlack30, darkenValue: 0.2))
                        
                        Spacer()
                        
                        Button(action: {
                            onItemSelected(item)
                        }) {
                            Image(uiImage: selectedItem == item ? .selectedCheck : .notSelectedCheck)
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
//    UniversityCellView()
//}
