//
//  CollegeSectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/27/25.
//

import SwiftUI

import DesignSystem
import Shared
import Resource
import Lottie

struct CollegeSectionView: View {
    
    @State var viewModel: CollegeInfoViewModel

    var body: some View {
        Group {
            if let collegesInfo = viewModel.collegesInfoModel {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(collegesInfo) { item in
                            HStack(spacing: 0) {
                                Text(item.collegesName)
                                    .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                                    .foregroundStyle(DesignSystem.Color.swiftUIColorToDarken(.terbuckBlack30, darkenValue: 0.2))
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.selectItem(item)
                                }) {
                                    Image(uiImage: viewModel.selectedItemForUI == item ? .selectedCheck : .notSelectedCheck)
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
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    LottieView(animation: .named("LoadingIndicator", bundle: ResourceResources.bundle))
                        .playing(loopMode: .loop)
                        .animationSpeed(1)
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.collegesInfoModel != nil)
    }
}

//#Preview {
//    MajorSectionView()
//}
