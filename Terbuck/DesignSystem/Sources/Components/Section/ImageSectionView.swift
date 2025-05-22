//
//  ImageSectionView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

public struct ImageSectionView<T: ImageSectionDisplayable>: View {
    
    // MARK: - Properties
    
    let type: SectionType
    let models: [T]
    let onImageTapped: (Int) -> Void
    
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let horizontalSpacing : CGFloat
    
    // MARK: - Init
    
    public init(
        type: SectionType,
        models: [ImageSectionDisplayable],
        onImageTapped: @escaping (Int) -> Void
    ) {
        self.type = type
        self.models = models as! [T]
        self.onImageTapped = onImageTapped
        
        self.imageWidth = type == .detailPartner ? 335 : 203
        self.imageHeight = type == .detailPartner ? 335 : 203
        self.horizontalSpacing = type == .detailPartner ? 10 : 8
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: horizontalSpacing) {
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
