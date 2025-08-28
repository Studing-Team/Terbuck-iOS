//
//  InfomationSectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import SwiftUI
import DesignSystem

enum SectionType {
    case location
    case university
}

struct InfomationSectionView: View {
    
    @ObservedObject var viewModel: UniversityViewModel
    @State private var isExpanded: Bool = true
    @State private var sectionType: SectionType = .university
    @State private var selectedSectionIndex: Int = 0
    
    var selectedSection: UniversityInfoModel {
        sections[selectedSectionIndex]
    }
    
    let sections = [
        UniversityInfoModel(
            title: "강남 · 서초 · 송파 · 강동",
            items: ["KCD대학교", "서울교육대학교", "총신대학교(서초캠퍼스)", "한국체육대학교", "한영신학대학교" , "홍익대학교", "연세대학교", "이화여자대학교", "서강대학교", "추계예술대학교"]
        ),
        UniversityInfoModel(
            title: "마포 · 서대문 · 은평",
            items: ["홍익대학교", "연세대학교", "이화여자대학교", "서강대학교", "추계예술대학교", "KCD대학교", "서울교육대학교", "총신대학교(서초캠퍼스)", "한국체육대학교", "한영신학대학교" ]
        ),
        UniversityInfoModel(
            title: "종로 · 중구 · 성동",
            items: ["서울대학교", "한양대학교", "성균관대학교", "동국대학교", "중앙대학교", "홍익대학교", "연세대학교", "이화여자대학교", "서강대학교", "추계예술대학교"]
        )
    ]
    
    
    var body: some View {
        VStack(spacing: 18) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    // 먼저 접기
                    isExpanded = false
                    
                    // 잠시 후 타입 변경하고 다시 펼치기
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        sectionType = sectionType == .university ? .location : .university
                        viewModel.selectItem(nil)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded = true
                        }
                    }
                }
            }) {
                HStack(spacing: 0) {
                    Text(selectedSection.title)
                        .font(DesignSystem.Font.swiftUIFont(.textSemi16))
                        .foregroundStyle(DesignSystem.Color.swiftUIColor(.terbuckBlack50))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(DesignSystem.Color.swiftUIColor(.terbuckBlack10))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.vertical, 16.5)
                .padding(.horizontal, 20)
                .background(DesignSystem.Color.swiftUIColor(.terbuckWhite5))
                .cornerRadius(8)
            }
            
            // 아코디언 내용
            VStack(spacing: 0) {
                if sectionType == .university {
                    UniversitySectionView(
                        section: selectedSection.items,
                        selectedItem: viewModel.selectedItemForUI,
                        onItemSelected: { item in
                            viewModel.selectItem(item)
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                } else if sectionType == .location {
                    LocationSectionView(
                        section: sections.map { $0.title },
                        onItemSelected: { item in
                            if let index = sections.firstIndex(where: { $0.title == item }) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                    selectedSectionIndex = index
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        sectionType = .university
                                        
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isExpanded = true
                                        }
                                    }
                                }
                            }
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .scaleEffect(y: isExpanded ? 1 : 0, anchor: .top)
            .clipped()
        }
        .padding(.horizontal, 20)
        .onAppear {
            // 초기 상태: university 모드에서 펼쳐진 상태
            sectionType = .university
            isExpanded = true
        }
    }
}

//#Preview {
//    InfomationSectionView()
//}


struct UniversityInfoModel {
    let title: String
    let items: [String]
}
