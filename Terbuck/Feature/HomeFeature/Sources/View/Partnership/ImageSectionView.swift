//
//  ImageSectionView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

struct ImageSectionView: View {
    
    // MARK: - Properties
    
    let models: [DetailPartnerImageModel]
    let onImageTapped: (Int) -> Void
    
    private let imageWidth: CGFloat = 335
    private let imageHeight: CGFloat = 335
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(models.indices, id: \.self) { index in
                        AsyncImageViewRepresentable(
                            imageData: models[index].images,
                            type: .partnership
                        )
                        .frame(width: imageWidth * (geometry.size.width / 375), height:  imageWidth * (geometry.size.width / 375))
                        .clipped()
                        .onTapGesture {
                            onImageTapped(index)
                        }
                        .contentShape(Rectangle())
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
