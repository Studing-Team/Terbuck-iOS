//
//  PreviewImageView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

public struct PreviewImageView: View {
    
    // MARK: - Properties
    
    @State var viewModel: PartnershipViewModel
    
    public init(
        viewModel: PartnershipViewModel
    ) {
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
                                    Image(uiImage: UIImage(data: data.images[index])!)
                                        .resizable()
                                        .frame(width: geometry.size.width, height: geometry.size.width)
                                        .clipped()
                                        .id(index) // ID 설정
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
