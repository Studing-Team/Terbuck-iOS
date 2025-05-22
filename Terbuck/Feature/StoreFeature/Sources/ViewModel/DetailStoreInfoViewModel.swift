//
//  DetailStoreInfoViewModel.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/14/25.
//

import UIKit
import Observation

import Shared

public enum DetailStoreSection: CaseIterable, Hashable {
    case title
    case image
    case benefit
}

public enum DetailStoreItem: Hashable {
    case storeTitle(DetailStoreHeaderModel)
    case storeImage([DetailStoreImageModel])
    case storeBenefit([DetailStoreBenefitModel])
}

@Observable
public final class DetailStoreInfoViewModel: PreviewImageDisplayable {
    
    typealias StoreBenefitResult = (DetailStoreHeaderModel, [DetailStoreImageModel]?, [DetailStoreBenefitModel])
    
    public var sectionData: [DetailStoreSection: DetailStoreItem] = [:]
    public var selectImageData: PreviewImageModel?
    
    public func fetchStoreBenefitData() {
        let (headerModel, imageData, contentModel) = getStoreBenefit()
        
        var sectionData: [DetailStoreSection: DetailStoreItem] = [:]
        sectionData[.title] = .storeTitle(headerModel)
        
        if let imageData {
            sectionData[.image] = .storeImage(imageData)
        }
        
        sectionData[.benefit] = .storeBenefit(contentModel)
        
        self.sectionData = sectionData
    }
    
    public func tappendImageSection(index: Int) {
        guard let titleItem = sectionData[.title], case .storeTitle(let titleModel) = titleItem else { return }
        
        guard let imageItem = sectionData[.image], case .storeImage(let imageModel) = imageItem else { return }
        
        selectImageData = PreviewImageModel(imageIndex: index,
                                            title: titleModel.storeName,
                                            images: imageModel.map { $0.images })
    }
}

// MARK: - Private Extension

private extension DetailStoreInfoViewModel {
    func getStoreBenefit() -> StoreBenefitResult {
        let headerModel = DetailStoreHeaderModel(
            storeName: "터벅터벅 공릉점",
            storeAddress: "노원구 동일로190길 49 지층"
        )
        
        let imageData: [DetailStoreImageModel] = [
            DetailStoreImageModel(DetailStoreimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!),
            DetailStoreImageModel(DetailStoreimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!),
            DetailStoreImageModel(DetailStoreimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!)
        ]
        
        let contentModel = [
            DetailStoreBenefitModel(benefitTitle: "18시 이전 방문 고객 소주 1병 제공"),
            DetailStoreBenefitModel(benefitTitle: "25,000원 이상 주문 시, 빙수 또는 감자튀김 제공"),
            DetailStoreBenefitModel(benefitTitle: "소주 볼링핀(10병) 인스타그램 스토리 총학과 꼬치네 계정 태그와 함께 업로드 시 치즈스틱 제공"),
            DetailStoreBenefitModel(benefitTitle: "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공"),
            DetailStoreBenefitModel(benefitTitle: "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공2"),
            DetailStoreBenefitModel(benefitTitle: "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공3"),
            DetailStoreBenefitModel(benefitTitle: "메이게츠에서의 영수증(결제일로부터 최대 3일) 보여줄 시 꼬치네에서 소주 1병 제공4")
        ]
        
        return (headerModel, imageData, contentModel)
    }
}
