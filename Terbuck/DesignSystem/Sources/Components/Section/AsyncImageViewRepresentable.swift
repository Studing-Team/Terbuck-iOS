//
//  AsyncImageViewRepresentable.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/14/25.
//

import SwiftUI

import Shared

// AsyncImageView를 SwiftUI에서 사용하기 위한 UIViewRepresentable
public struct AsyncImageViewRepresentable: UIViewRepresentable {
    let imageURL: String
    let type: ImageType
    
    public func makeUIView(context: Context) -> AsyncImageView {
        let imageView = AsyncImageView(frame: .zero)
        imageView.setImage(imageURL, type: type)
        imageView.isUserInteractionEnabled = true

        return imageView
    }
    
    public func updateUIView(_ uiView: AsyncImageView, context: Context) {
        uiView.setImage(imageURL, type: type)
    }
}
