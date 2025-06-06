//
//  AsyncImageView.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 5/9/25.
//

import UIKit

import CoreNetwork
import Shared

public final class AsyncImageView: UIView {

    // MARK: - Properties
    
    private var imageURL: URL?
    private var currentTask: Task<Void, Never>?
    
    // MARK: - UI Properties

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public

    /// 이미지를 설정하는 메인 메서드
    /// - Parameters:
    ///   - urlString: 이미지 URL 문자열
    ///   - type: 이미지 타입 (로고, 포스트 등)
    ///   - forceReload: 캐시 무시하고 강제로 새로 로드할지 여부
    public func setImage(_ urlString: String, type: ImageType, forceReload: Bool = false) {
        activityIndicator.startAnimating()
        imageView.contentMode = type.mode
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: setting default image - (\(urlString))")
            activityIndicator.stopAnimating()
            return
        }
        
        // 캐시 확인
        if !forceReload, let cachedData = ImageCacheManager.shared.data(for: urlString) {
            self.imageView.image = UIImage(data: cachedData)
            print("✅ Loaded from cache")
            activityIndicator.stopAnimating()
            return
        }
        
        imageURL = url
        
        currentTask = Task {
            do {
                let data = try await NetworkManager.shared.requestImage(url: url)
                
                if Task.isCancelled { return }
                
                guard let downsampled = UIImage.downsample(imageData: data, to: type.imageSize, scale: UIScreen.main.scale) else {
                    throw URLError(.cannotDecodeContentData)
                }

                ImageCacheManager.shared.setData(downsampled, for: urlString)

                await MainActor.run {
                    self.alpha = 0
                    self.imageView.image = UIImage(data: downsampled)
                    UIView.animate(withDuration: 0.3) {
                        self.alpha = 1
                    }
                    activityIndicator.stopAnimating()
                    print("✅ Loaded and downsampled from network")
                }
            } catch {
                print("❌ Image load error: \(error.localizedDescription)")
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    public func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    // MARK: - Private

    private func setupView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        addSubviews(activityIndicator, imageView)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setDefaultImage(for type: ImageType) -> UIImage? {
        return nil
//        switch type {
//
//        case .storeListImage:
//            
//        case .storeInfoImage:
//            
//        case .storeDetailImage:
//            
//        case .partnershipImage:
//            
//        case .studentIdImage:
//            
//        }
    }
}

public enum ImageType {
    case storeListImage
    case storeInfoImage
    case storeDetailImage
    case partnershipImage
    case studentIdImage
    
    public var imageSize: CGSize {
        switch self {
        case .storeListImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 88 / 375, height: SizeLiterals.Screen.screenHeight * 88 / 812)
        case .storeInfoImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 203 / 375, height: SizeLiterals.Screen.screenHeight * 203 / 812)
        case .storeDetailImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 375 / 375, height: SizeLiterals.Screen.screenHeight * 375 / 812)
        case .partnershipImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 320 / 375, height: SizeLiterals.Screen.screenHeight * 320 / 812)
        case .studentIdImage:
            return CGSize(width: SizeLiterals.Screen.screenWidth * 265 / 375, height: SizeLiterals.Screen.screenHeight * 424 / 812)
        }
    }
    
    var mode: UIView.ContentMode {
        switch self{
        case .storeListImage:
            return .scaleAspectFill
        default:
            return .scaleAspectFit
        }
    }
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        // 캐시 용량 설정
        cache.countLimit = 100 // 최대 데이터 개수
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
    }
    
    // Data 가져오기
    func data(for key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    // Data 저장
    func setData(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    // Data 삭제
    func removeData(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    // 모든 캐시 삭제
    func clearCache() {
        cache.removeAllObjects()
    }
}
