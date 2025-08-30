//
//  MajorSectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import SwiftUI
import DesignSystem
import Shared

struct MajorSectionView: View {
    
    @ObservedObject var viewModel: MajorInfoViewModel
    
    let sections = [
        MajorInfoModel(majorName: "공과대학"),
        MajorInfoModel(majorName: "인문사회대학"),
        MajorInfoModel(majorName: "기술융합대학"),
        MajorInfoModel(majorName: "조형대학"),
        MajorInfoModel(majorName: "창의융합대학"),
        MajorInfoModel(majorName: "미래융합대학"),
        MajorInfoModel(majorName: "공과대학"),
        MajorInfoModel(majorName: "인문사회대학"),
        MajorInfoModel(majorName: "기술융합대학"),
        MajorInfoModel(majorName: "조형대학"),
        MajorInfoModel(majorName: "창의융합대학"),
        MajorInfoModel(majorName: "미래융합대학")
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(sections) { item in
                    HStack(spacing: 0) {
                        Text(item.majorName)
                            .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                            .foregroundStyle(DesignSystem.Color.swiftUIColorToDarken(.terbuckBlack30, darkenValue: 0.2))
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.selectItem(item.majorName)
                        }) {
                            Image(uiImage: viewModel.selectedItemForUI == item.majorName ? .selectedCheck : .notSelectedCheck)
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
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    MajorSectionView()
//}
