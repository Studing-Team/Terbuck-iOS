//
//  PartnershipViewModel.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//


import UIKit
import Observation

import Shared
import Combine

@Observable
public final class PartnershipViewModel: PreviewImageDisplayable {
    
    // MARK: - Properties
    
    typealias PartnershipBenefitResult = (DetailPartnershipModel, [DetailPartnerImageModel]?, DetailPartnerBenefitModel)
    
    public var sectionData: [PartnershipSection: PartnerBenefitItem] = [:]
    public var selectImageData: PreviewImageModel?
    
    private let detailPartnershipUseCase: DetailPartnershipUseCase
    private(set) var instarURL: String?
    private let partnershipId: Int
    
    // MARK: - Init
    
    public init(
        detailPartnershipUseCase: DetailPartnershipUseCase,
        partnershipId: Int
    ) {
        self.detailPartnershipUseCase = detailPartnershipUseCase
        self.partnershipId = partnershipId
    }
}

// MARK: - Public Extension

public extension PartnershipViewModel {
    func tappendImageSection(index: Int) {
        guard let titleItem = sectionData[.title], case .partnerTitleHeader(let titleModel) = titleItem else { return }
        
        guard let imageItem = sectionData[.image], case .partnerImage(let imageModel) = imageItem, let models = imageModel else { return }
        
        selectImageData = PreviewImageModel(imageIndex: index,
                                            title: titleModel.partnershipName,
                                            images: models.map { $0.imageURL })
    }
    
    func fetchPartnershipData() async {
        do {
            let (headerModel, imageData, contentModel) = try await getDetailPartnershipBenefit(partnershipId)

            var sectionData: [PartnershipSection: PartnerBenefitItem] = [:]
            sectionData[.title] = .partnerTitleHeader(headerModel)
            if let imageData {
                sectionData[.image] = .partnerImage(imageData)
            }
            sectionData[.content] = .benefit(contentModel)

            self.sectionData = sectionData
        } catch {
            print("파트너십 상세 조회 실패: \(error)")
        }
    }
}

// MARK: - Private API Extension

private extension PartnershipViewModel {
    func getDetailPartnershipBenefit(_ partnershipId: Int) async throws -> PartnershipBenefitResult {
        do {
            let result = try await self.detailPartnershipUseCase.execute(partnershipId: partnershipId)
            instarURL = result.3
            return (result.0, result.1, result.2)
        } catch (let error) {
            print(error.localizedDescription)
            throw error
        }
    }
}
