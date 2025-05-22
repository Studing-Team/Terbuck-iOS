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
        .onAppear {
            viewModel.fetchStoreBenefitData()
        }
    }
}

// MARK: - Private Extension

private extension DetailStoreInfoView {
    func titleSection() -> some View {
        if let titleItem = viewModel.sectionData[.title], case .storeTitle(let model) = titleItem {
            TitleSectionView<DetailStoreHeaderModel>(
                type: type,
                model: model
            )
        } else {
            TitleSectionView<DetailStoreHeaderModel>(
                type: type,
                model: DetailStoreHeaderModel(storeName: "데이터 없음", storeAddress: "데이터 없음")
            )
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
            } else {
                // TODO: - loading 안됐을때
            }
        }
    }
    
    func benefitsSection() -> some View {
        VStack {
            if let benefitItem = viewModel.sectionData[.benefit], case .storeBenefit(let models) = benefitItem {
                BenefitSectionView(benefitModel: models)
            }
        }
    }
}



struct BenefitSectionView: View {
    
    let benefitModel: [DetailStoreBenefitModel]
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            HStack(spacing: 4) {
                Image(uiImage: .selectStoreIcon)
                
                Text("혜택 \(benefitModel.count)가지")
                    .font(DesignSystem.Font.swiftUIFont(.textSemi18))
                    .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
            }
            .padding(.vertical, 15)
            .padding(.bottom, 3)
            
            ForEach(benefitModel, id: \.self) { model in
                Text(model.benefitTitle)
                    .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                    .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 15)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(DesignSystem.Color.swiftUIColor(.terbuckWhite3))
                    }
                    .padding(.bottom, 8)
                    .onAppear {
                        print(model.benefitTitle)
                    }
            }
        }
//        ScrollView {
//            VStack(alignment: .leading,spacing: 0) {
//                ForEach(benefitModel, id: \.self) { model in
//                    Text(model.benefitTitle)
//                        .font(DesignSystem.Font.swiftUIFont(.textRegular14))
//                        .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 18)
//                        .padding(.horizontal, 15)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(DesignSystem.Color.swiftUIColor(.terbuckWhite3))
//                        }
//                        .padding(.bottom, 8)
//                }
//            }
//            .padding()
//        }
    }
}
