//
//  InfomationSectionView.swift
//  UniversityInfoFeature
//
//  Created by ParkJunHyuk on 8/26/25.
//

import SwiftUI
import DesignSystem
import Resource
import Lottie

enum SectionType {
    case location
    case university
}

struct InfomationSectionView: View {
    
    @State var viewModel: UniversityViewModel
    @State private var isExpanded: Bool = true
    @State private var sectionType: SectionType = .university
    @State private var selectedSectionIndex: Int = 0
    
    // MARK: - Properties
    
    var selectedSection: UniversityInfoModel? {
        guard let model = viewModel.universityInfoModel,
              model.indices.contains(selectedSectionIndex) else {
            return nil
        }
        
        return model[selectedSectionIndex]
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let universityInfo = viewModel.universityInfoModel, let currentSection = selectedSection {
                VStack(spacing: 18) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded = false
                            
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
                            Text(currentSection.title)
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
                
                    accordionSectionView(universityInfo: universityInfo, currentSection: currentSection)
                }
                .padding(.horizontal, 20)
                .onAppear {
                    sectionType = .university
                    isExpanded = true
                }
                .transition(.opacity)
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    
                    LottieView(animation: .named("LoadingIndicator", bundle: ResourceResources.bundle))
                        .playing(loopMode: .loop)
                        .animationSpeed(1)
                        
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.universityInfoModel != nil)
    }
    
    func accordionSectionView(universityInfo: [UniversityInfoModel], currentSection: UniversityInfoModel) -> some View {
        VStack(spacing: 0) {
            if sectionType == .university {
                UniversitySectionView(
                    section: currentSection.items,
                    selectedItem: viewModel.selectedItemForUI,
                    onItemSelected: { item in
                        viewModel.selectItem(item)
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            } else if sectionType == .location {
                LocationSectionView(
                    section: universityInfo.map { $0.title },
                    onItemSelected: { item in
                        if let index = universityInfo.firstIndex(where: { $0.title == item }) {
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
    }
}

//#Preview {
//    InfomationSectionView()
//}
