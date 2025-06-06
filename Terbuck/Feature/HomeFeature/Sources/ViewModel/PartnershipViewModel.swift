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
            print("입력받은 ID", partnershipId)
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
    
//    func fetchPartnershipData() {
//        let (headerModel, imageData, contentModel) = getDetailPartnershipBenefit(partnershipId)
//        
//        var sectionData: [PartnershipSection: PartnerBenefitItem] = [:]
//        sectionData[.title] = .partnerTitleHeader(headerModel)
//        if let imageData {
//            sectionData[.image] = .partnerImage(imageData)
//        }
//        sectionData[.content] = .benefit(contentModel)
//        
//        self.sectionData = sectionData
//    }
}

// MARK: - Private API Extension

private extension PartnershipViewModel {
    func getDetailPartnershipBenefit(_ partnershipId: Int) async throws -> PartnershipBenefitResult {
        do {
            let result = try await self.detailPartnershipUseCase.execute(partnershipId: partnershipId)
            return result
        } catch (let error) {
            print(error.localizedDescription)
            throw error
        }
    }
    
//    func getPartnershipBenefit() -> PartnershipBenefitResult {
//        let headerModel = DetailPartnershipModel(
//            partnershipName: "Adobe 공동구매",
//            partnerCategoryType: .studentAssociation
//        )
//        let imageData: [DetailPartnerImageModel] = [
//            DetailPartnerImageModel(DetailPartnerimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!),
//            DetailPartnerImageModel(DetailPartnerimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!),
//            DetailPartnerImageModel(DetailPartnerimages: UIImage.dumyPartnership.jpegData(compressionQuality: 1)!)
//        ]
//        
//        let contentModel = DetailPartnerBenefitModel(
//            content: """
//            🎨 전공 과제, 포스터, 영상 편집까지, 이제는 프로처럼
//            서울과학기술대학교 재학생이라면, Adobe Creative Cloud의 전 제품군을 정가보다 훨씬 저렴한 가격으로 이용할 수 있어요.
//
//            🖥️ 제공되는 프로그램은요?
//
//            ✅ Photoshop – 이미지 편집의 표준
//            ✅ Illustrator – 일러스트와 로고 디자인 필수
//            ✅ Premiere Pro – 고급 영상 편집
//            ✅ After Effects – 모션 그래픽과 특수효과
//            ✅ InDesign, Lightroom, XD 등 – 20개 이상의 Adobe 앱 제공
//
//            디자인 전공자뿐만 아니라,
//            동아리 포스터 제작, 유튜브 영상 편집, 졸업전시 포트폴리오 등 전공과 관계없이 누구에게나 유용한 툴이에요.
//
//            🙋 이런 학생에게 특히 추천해요!
//            전공 수업 과제를 할 때, 항상 프로그램 체험판 만료 때문에 불편했던 분
//            디자인/영상 툴에 입문하고 싶은데, 가격이 부담됐던 분
//            졸업작품, 포트폴리오 제작을 준비 중인 학생
//            유튜브, SNS 콘텐츠를 직접 제작해보고 싶은 크리에이터 지망생
//
//            🧾 이용 방법은요?
//            1. 터벅 앱에서 [Adobe 제휴 혜택] 카드 클릭
//            2. [학교명] 이메일(@school.ac.kr) 주소로 로그인
//            3. 학생 인증 후 할인 가격으로 결제
//            4. Adobe 공식 페이지에서 Creative Cloud 설치 후 사용
//
//            ※ 할인율과 가격은 학교 및 시즌에 따라 다를 수 있어요.
//            ※ 현재 등록된 이메일 외에 졸업생, 휴학생은 이용이 제한될 수 있어요.
//
//            💬 터벅 TIP
//            터벅에서는 Adobe 외에도 다양한 소프트웨어/디지털 서비스 제휴 혜택을
//            모두 한눈에 확인할 수 있어요.
//            매달 업데이트되는 대학생 전용 혜택 놓치지 말고,
//            홈 화면 제휴관에서 확인해보세요!
//            """
//        )
//        
//        return (headerModel, imageData, contentModel)
//    }
}
