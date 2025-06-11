//
//  PartnershipView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

import DesignSystem

struct PartnershipView: View {
    @State var viewModel: PartnershipViewModel
    
    let onBackButtonTapped: () -> Void
    let onImageTapped: (Int) -> Void
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    if let titleItem = viewModel.sectionData[.title], case .partnerTitleHeader(let model) = titleItem {
                        TitleSectionView<DetailPartnershipModel>(type: .detailPartner, model: model)
                    }
                    
                    if let imageItem = viewModel.sectionData[.image], case .partnerImage(let models) = imageItem, let models = models {
                        ImageSectionView<DetailPartnerImageModel>(
                            type: .detailPartner,
                            models: models,
                            onImageTapped: onImageTapped
                        )
                        .frame(height: 335 * (geometry.size.width / 375))
                    }
                    
                    if let contentItem = viewModel.sectionData[.content], case .benefit(let model) = contentItem {
                        ContentSectionView(model: model)
                            .frame(minHeight: 100)
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                    }
                    
                    Button(action: {
                        guard let url = URL(string: viewModel.instarURL ?? ""),
                              UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url, options: [:])
                    }) {
                        Text("인스타그램 게시물 보기")
                            .font(DesignSystem.Font.swiftUIFont(.textSemi18))
                            .foregroundColor(Color.white)
                    }
                    .frame(height: 52)
                    .frame(maxWidth: .infinity)
                    .background(DesignSystem.Color.swiftUIColor(.terbuckGreen50))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.white)
        }
    }
}
