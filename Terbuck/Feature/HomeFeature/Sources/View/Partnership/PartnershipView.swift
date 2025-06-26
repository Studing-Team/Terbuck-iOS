//
//  PartnershipView.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/12/25.
//

import SwiftUI

import DesignSystem
import Shared

struct PartnershipView: View {
    @State var viewModel: PartnershipViewModel
    @State private var showToast: Bool = false
    @State private var toastOpacity: Double = 0
    @State private var toastYOffset: CGFloat = 20 // 시작할 때 아래쪽에 위치
    
    let onBackButtonTapped: () -> Void
    let onImageTapped: (Int) -> Void
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            if viewModel.sectionData.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if let titleItem = viewModel.sectionData[.title], case .partnerTitleHeader(let model) = titleItem {
                            TitleSectionView<DetailPartnershipModel>(type: .detailPartner, model: model)
                        }
                        
                        if let imageItem = viewModel.sectionData[.image], case .partnerImage(let models) = imageItem, let models = models {
                            ImageSectionView<DetailPartnerImageModel>(
                                type: .detailPartner,
                                models: models,
                                onImageTapped: onImageTapped
                            )
                            .frame(height: 335 * (geometry.size.width / 375))
                        }
                        
                        if let contentItem = viewModel.sectionData[.content], case .benefit(let model) = contentItem {
                            ContentSectionView(model: model)
                                .frame(minHeight: 100)
                                .padding(.horizontal, 20)
                                .padding(.top, 15)
                                .padding(.bottom, 30)
                        }
                        
                        ZStack {
                            Button(action: {
                                MixpanelManager.shared.track(eventType: TrackEventType.Home.moveInstagram)
                                
                                guard let url = URL(string: viewModel.instarURL ?? ""),
                                      UIApplication.shared.canOpenURL(url) else { return }
                                UIApplication.shared.open(url, options: [:])
                            }) {
                                Text("인스타그램 게시물 보기")
                                    .font(DesignSystem.Font.swiftUIFont(.textSemi18))
                                    .foregroundColor(Color.white)
                            }
                            .frame(height: 52)
                            .frame(maxWidth: .infinity)
                            .background(DesignSystem.Color.swiftUIColor(.terbuckGreen50))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                            .onScrollVisibilityChange { isVisible in
                                if isVisible {
                                    showToast = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            toastOpacity = 1
                                            toastYOffset = 0
                                        }
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            toastOpacity = 0
                                            toastYOffset = 20 // 아래로 이동
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            showToast = false
                                            // 다음 애니메이션을 위해 초기 상태로 리셋
                                            toastYOffset = 20
                                        }
                                    }
                                } else {
                                    // 버튼이 안보이면 즉시 사라지는 애니메이션
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        toastOpacity = 0
                                        toastYOffset = 20
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showToast = false
                                        toastYOffset = 20
                                    }
                                }
                            }

                            if showToast {
                                toastMessageView()
                                    .padding(.horizontal, 20)
                                    .padding(.top, -85)
                                    .opacity(toastOpacity)
                                    .offset(y: toastYOffset)
                            }
                        }
                    }
                    .background(Color.white)
                }
            }
        }
    }

    func toastMessageView() -> some View {
        HStack(spacing: 4) {
            Image(uiImage: .moreBenefitIcon)
            
            Text("문의하려면 아래 버튼을 눌러주세요.")
                .font(DesignSystem.Font.swiftUIFont(.textRegular14))
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.Color.swiftUIColor(.terbuckToastBackground))
        }
    }
}

// MARK: - ViewModifier

struct ScrollBasedVisibilityModifier: ViewModifier {
    let onVisibilityChange: (Bool) -> Void
    @State private var previousVisibility: Bool? = nil // 이전 상태 저장
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self,
                                  value: geometry.frame(in: .named("scroll")))
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { frame in
                checkVisibility(frame: frame)
            }
    }
    
    private func checkVisibility(frame: CGRect) {
        // 화면 크기 구하기
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            updateVisibilityIfChanged(false)
            return
        }
        
        let screenHeight = window.bounds.height
        
        // 뷰가 화면에 보이는지 체크 (스크롤 좌표계 기준)
        let isVisible = frame.maxY > 0 && frame.minY < screenHeight
        
        updateVisibilityIfChanged(isVisible)
    }
    
    private func updateVisibilityIfChanged(_ newVisibility: Bool) {
        // 이전 값과 다를 때만 콜백 호출
        if previousVisibility != newVisibility {
            previousVisibility = newVisibility
            onVisibilityChange(newVisibility)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func onScrollVisibilityChange(_ callback: @escaping (Bool) -> Void) -> some View {
        self.modifier(ScrollBasedVisibilityModifier(onVisibilityChange: callback))
    }
}
