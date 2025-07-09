//
//  RegisterStudentCardViewController.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/25/25.
//

import UIKit
import Combine
import Photos
import PhotosUI

import DesignSystem
import Shared

import SnapKit
import Then

public final class RegisterStudentCardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private let registerStudentCardViewModel: RegisterStudentCardViewModel
    
    // MARK: - Combine Properties
    
    private var registerStudentIdImageSubject = PassthroughSubject<Data, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customNavBar = CustomNavigationView(type: .nomal, title: "학생증 등록")
    private let containerView = UIView()
    private let studentIdImageView = UIImageView()
    private let registerStudentIDCardButton = UIButton()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let bottomButton = TerbuckBottomButton(type: .register, isEnabled: false)
    
    private let textFieldStackView = UIStackView()
    private let nameTextFieldView = TerbuckTextFieldView(type: .name)
    private let studentIdTextFieldView = TerbuckTextFieldView(type: .studentID)
    
    // MARK: - Init
    
    public init(
        viewModel: RegisterStudentCardViewModel
    ) {
        self.registerStudentCardViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        bindViewModel()
        setupKeyboardHandling()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ToastManager.shared.showToast(from: self, type: .noticeStudentCard)
    }
    
    private func presentPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1 // ✅ 이미지 1장만 선택 가능
        configuration.filter = .images   // ✅ 이미지만 필터링

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Private Extensions

private extension RegisterStudentCardViewController {
    func bindViewModel() {
        let input = RegisterStudentCardViewModel.Input(
            registerStudentIdImage: registerStudentIdImageSubject.eraseToAnyPublisher(),
            registerStudentName: nameTextFieldView.textPublisher,
            registerStudentId: studentIdTextFieldView.textPublisher,
            registerStudentIDCardButtonTapped: registerStudentIDCardButton.tapPublisher,
            bottomButtonTapped: bottomButton.tapPublisher
        )
        
        let output = registerStudentCardViewModel.transform(input: input)
        
        output.registerStudentIDCardButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentPhotoPicker()
            }
            .store(in: &cancellables)
        
        output.registerBottomButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] buttonState in
                self?.bottomButton.isUserInteractionEnabled = buttonState
            }
            .store(in: &cancellables)
        
        output.buttonButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .userAuthDidUpdate, object: nil)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension RegisterStudentCardViewController {
    func setupStyle() {
        self.view.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        titleLabel.do {
            $0.text = "혜택을 받기 위해\n학생증을 등록해주세요"
            $0.font = DesignSystem.Font.uiFont(.titleSemi20)
            $0.numberOfLines = 2
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack50)
        }
        
        subTitleLabel.do {
            $0.text = "학생증 등록은 24시간 안에 마무리 할게요 :)"
            $0.font = DesignSystem.Font.uiFont(.textRegular14)
            $0.textColor = DesignSystem.Color.uiColor(.terbuckBlack30)
        }
        
        registerStudentIDCardButton.do {
            $0.setTitle("학생증 이미지 넣기", for: .normal)
            $0.setTitleColor(DesignSystem.Color.uiColor(.terbuckBlack10), for: .normal)
            $0.titleLabel?.font = DesignSystem.Font.uiFont(.captionMedium12)
            $0.backgroundColor = DesignSystem.Color.uiColor(.terbuckWhite5)
            $0.layer.cornerRadius = 16
            $0.isHidden = false
        }
        
        textFieldStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillProportionally
            $0.addArrangedSubviews(nameTextFieldView, studentIdTextFieldView)
        }
        
        studentIdTextFieldView.keyboardType = .numberPad
        
        studentIdImageView.do {
            $0.layer.cornerRadius = 16
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(customNavBar, titleLabel, subTitleLabel, containerView, textFieldStackView, bottomButton)
        containerView.addSubviews(registerStudentIDCardButton, studentIdImageView)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(230)
        }

        [registerStudentIDCardButton, studentIdImageView].forEach {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(registerStudentIDCardButton.snp.bottom).offset(view.convertByHeightRatio(25))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(view.convertByHeightRatio(120))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension RegisterStudentCardViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard !results.isEmpty else {
            return
        }
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                guard let data else {
                    print("❌ 데이터 로드 실패: \(error?.localizedDescription ?? "알 수 없음")")
                    return
                }
                
                guard let imageData = UIImage.downsample(imageData: data, to: ImageType.studentIdImage.imageSize, scale: UIScreen.main.scale) else { return }
                
                DispatchQueue.main.async {
                    self.registerStudentIdImageSubject.send(imageData)
                    self.studentIdImageView.image = UIImage(data: imageData) // 필요 시 변환
                    self.studentIdImageView.isHidden = false
                    self.registerStudentIDCardButton.isHidden = true
                }
            }
        }
    }
}

// MARK: - Show Preview

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("RegisterStudentCardViewController") {
//    RegisterStudentCardViewController()
//        .showPreview()
//}
//#endif

extension NSItemProvider {
    func loadImage() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            self.loadObject(ofClass: UIImage.self) { object, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if let image = object as? UIImage {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: NSError(domain: "InvalidImageType", code: -1))
                }
            }
        }
    }
}
