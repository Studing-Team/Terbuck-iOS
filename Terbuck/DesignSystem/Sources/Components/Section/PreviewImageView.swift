//
//  PreviewImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

public struct PreviewImageView: View {
    
    // MARK: - Properties
    
    let type: SectionType
    @State var viewModel: PreviewImageDisplayable
    
    // MARK: - Init
    
    public init(
        type: SectionType,
        viewModel: PreviewImageDisplayable
    ) {
        self.type = type
        self.viewModel = viewModel
    }

    // MARK: - Body
    
    public var body: some View {
        if let data = viewModel.selectImageData {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(data.images.indices, id: \.self) { index in
                                    
                                    AsyncImageViewRepresentable(
                                        imageURL: data.images[index],
                                        type: .partnershipImage
                                    )
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.viewAligned)
                        .onAppear {
                            // 처음 보일 index로 스크롤
                            proxy.scrollTo(data.imageIndex, anchor: .center)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
