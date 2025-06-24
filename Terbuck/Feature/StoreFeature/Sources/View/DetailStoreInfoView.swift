//
//  DetailStoreInfoView.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import DesignSystem
import Shared

struct DetailStoreInfoView: View {
    
    @State var viewModel: DetailStoreInfoViewModel
    
    // MARK: - Property
    
    let type: SectionType
    let onImageTapped: (Int) -> Void
    let onMoreBenefitTapped: ([String]) -> Void
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                titleSection()
                
                ScrollView(.vertical, showsIndicators: true) {
                    imagesSection(geometry)
    
                    benefitsSection()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 70)
                }
            }
        }
    }
}

// MARK: - Private Extension

private extension DetailStoreInfoView {
    func titleSection() -> some View {
        VStack(spacing: 0) {
            if let titleItem = viewModel.sectionData[.title], case .storeTitle(let model) = titleItem {
                TitleSectionView<DetailStoreHeaderModel>(
                    type: type,
                    model: model
                )
            }
        }
    }
    
    func imagesSection(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if let imageItem = viewModel.sectionData[.image], case .storeImage(let models) = imageItem {
                ImageSectionView<DetailStoreImageModel>(
                    type: type,
                    models: models,
                    onImageTapped: onImageTapped
                )
                .frame(height: 203 * (geometry.size.width / 375))
            }
        }
    }
    
    func benefitsSection() -> some View {
        VStack {
            if let benefitItem = viewModel.sectionData[.benefit], case .storeBenefit(let models) = benefitItem {
                benefitSectionView(benefitModel: models, storeUsagesList: viewModel.storeUsagesList)
            }
        }
    }
    
    func benefitSectionView(benefitModel: [DetailStoreBenefitModel], storeUsagesList: [String]) -> some View {
        VStack(alignment: .leading,spacing: 0) {
            HStack(spacing: 4) {
                Image(uiImage: .selectStoreIcon)
                
                Text("혜택 \(benefitModel.count)가지")
                    .font(DesignSystem.Font.swiftUIFont(.textSemi18))
                    .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                
                Spacer()
                
                if !storeUsagesList.isEmpty {
                    Button(action: {
                        viewModel.isUseagesListModal = true
                    }) {
                        Text("이용방법")
                            .font(DesignSystem.Font.swiftUIFont(.textSemi14))
                            .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack10))
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.vertical, 15)
            .padding(.bottom, 3)
            
            ForEach(benefitModel.indices, id: \.self) { index in
                HStack(spacing: 0) {
                    Text(benefitModel[index].benefitTitle)
                        .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                        .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 18)
                        .padding(.trailing, 20)
                    
                    if !benefitModel[index].detailList.isEmpty {
                        Button(action: {
                            viewModel.selectedBenefitIndex = index
                            viewModel.isShowModal = true
                            onMoreBenefitTapped(benefitModel[index].detailList)
                        }) {
                            Text("클릭")
                                .font(DesignSystem.Font.swiftUIFont(.textSemi14))
                                .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckGreen50))
                        }
                    }
                }
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(DesignSystem.Color.swiftUIColor(.terbuckWhite3))
                        .stroke(DesignSystem.Color.swiftUIColor(.terbuckGreen10), lineWidth: viewModel.selectedBenefitIndex == index ? 1 : 0)
                }
                .padding(.bottom, 8)
            }
        }
    }
}
