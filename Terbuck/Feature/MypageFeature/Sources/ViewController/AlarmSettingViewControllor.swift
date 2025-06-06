//
//  AlarmSettingViewControllor.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/21/25.
//

import UIKit
import Combine

import DesignSystem
import Shared

import SnapKit
import Then

final class AlarmSettingViewControllor: UIViewController {
    
    // MARK: - Properties
    
    private let alarmSettingViewModel: AlarmSettingViewModel
    weak var coordinator: MypageCoordinator?
    
    // MARK: - Combine Publishers Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let alarmInfomationView = AlarmInfomationView()
    private let customNavBar = CustomNavigationView(type: .nomal, title: "알림 설정")
    
    // MARK: - Init
    
    public init(
        alarmSettingViewModel: AlarmSettingViewModel,
        coordinator: MypageCoordinator
    ) {
        self.alarmSettingViewModel = alarmSettingViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("AlarmSettingViewController viewWillAppear")
        viewLifeCycleSubject.send(.viewWillAppear)
    }
}

// MARK: - Private Bind Extensions

private extension AlarmSettingViewControllor {
    func bindViewModel() {
        let input = AlarmSettingViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher()
        )
        
        let output = alarmSettingViewModel.transform(input: input)
        
        output.viewLifeCycleEventResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.alarmInfomationView.changeAlarmState(isAlarm: result)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension AlarmSettingViewControllor {
    func setupStyle() {
        customNavBar.setupBackButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupHierarchy() {
        self.view.addSubviews(customNavBar, alarmInfomationView)
    }
    
    func setupLayout() {
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        alarmInfomationView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(79)
        }
    }
    
    func setupDelegate() {
        
    }
}
