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
    
    public var storeURL: String?
    public var storeUsagesList = [String]()
    
    public var isUseagesListModal = false {
        didSet {
            onUseagesListModalChanged?(isUseagesListModal)
        }
    }

    public var onUseagesListModalChanged: ((Bool) -> Void)?
    
    private let searchDetailStoreUseCase: SearchDetailStoreUseCase
    private let storeId: Int
    
    // MARK: - Init
    
    public init(
        storeId: Int,
        searchDetailStoreUseCase: SearchDetailStoreUseCase
    ) {
        self.storeId = storeId
        self.searchDetailStoreUseCase = searchDetailStoreUseCase
    }
}

// MARK: - Public Extension

public extension DetailStoreInfoViewModel {
    func fetchDetailStoreBenefitData() async {
        do {
            let (headerModel, imageData, contentModel) = try await getDetailStoreData()
            
            var sectionData: [DetailStoreSection: DetailStoreItem] = [:]
            sectionData[.title] = .storeTitle(headerModel)
            
            if let imageData {
                sectionData[.image] = .storeImage(imageData)
            }
            
            sectionData[.benefit] = .storeBenefit(contentModel)
            
            self.sectionData = sectionData
        } catch {
            print("제휴업체 상세 조회 실패: \(error)")
        }
    }
    
    func tappendImageSection(index: Int) {
        guard let titleItem = sectionData[.title], case .storeTitle(let titleModel) = titleItem else { return }
        
        guard let imageItem = sectionData[.image], case .storeImage(let imageModel) = imageItem else { return }
        
        selectImageData = PreviewImageModel(imageIndex: index,
                                            title: titleModel.storeName,
                                            images: imageModel.map { $0.imageURL })
    }
}

// MARK: - Private API Extension

private extension DetailStoreInfoViewModel {    
    func getDetailStoreData() async throws -> StoreBenefitResult {
        do {
            
            let result = try await self.searchDetailStoreUseCase.execute(storeId: storeId)
            
            storeURL = result.3
            storeUsagesList = result.4
            
            return (result.0, result.1, result.2)
        } catch (let error) {
            print(error.localizedDescription)
            throw error
        }
    }
}
