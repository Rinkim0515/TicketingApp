//
//  MainController.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    // UI 컴포넌트
    private lazy var logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "GGV"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var welcomeUser: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.nanumSquare(size: 13, weight: .bold)
        return label
    }()
    
    private let segmentedControl = UISegmentedControl(items: ["영화 목록", "영화 검색", "마이페이지"])
    private let containerView = UIView()
    private let selectionIndicator = UIView()
    
    // 뷰 컨트롤러들
    private lazy var movieListVC = MovieListViewController(viewModel: MovieListViewModel())
    private lazy var searchVC = NowPlayingSearchViewController(viewModel: NowPlayingSearchViewModel())
    private lazy var myPageVC = MyPageViewController()
    
    private var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        loadUserInfo()
        segmentedControl.selectedSegmentIndex = 0
        updateViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateIndicatorPosition(animated: false)
    }
    init(currentViewController: UIViewController? = nil) {
        
        self.currentViewController = currentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 로고 뷰 설정
        view.addSubview(logoView)
        logoView.addSubview(logoImageView)
        view.addSubview(welcomeUser)
        
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(40)
            $0.width.equalTo(55)
        }
        
        welcomeUser.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(logoView.snp.bottom).offset(-10)
        }
        
        // 세그먼트 컨트롤 커스텀 스타일링
        let blueColor = UIColor.primaryBlue
        
        // 기본 스타일 제거
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        // 배경색 설정
        segmentedControl.backgroundColor = blueColor
        
        // 텍스트 스타일 설정
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.nanumSquare(size: 16, weight: .extraBold)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.nanumSquare(size: 16, weight: .extraBold)
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        // 세그먼트 컨트롤 이벤트 추가
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        // 선택 인디케이터 설정
        selectionIndicator.backgroundColor = .white
        selectionIndicator.layer.cornerRadius = 1.5
        
        // 뷰 추가 및 레이아웃 설정
        view.addSubview(segmentedControl)
        segmentedControl.addSubview(selectionIndicator)
        view.addSubview(containerView)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        selectionIndicator.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.width.equalTo(segmentedControl.snp.width).dividedBy(3)
            $0.bottom.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalTo(segmentedControl.snp.leading)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        updateViewController()
        updateIndicatorPosition(animated: true)
    }
    
    private func updateIndicatorPosition(animated: Bool) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let xPosition = segmentWidth * CGFloat(segmentedControl.selectedSegmentIndex)
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.selectionIndicator.snp.updateConstraints {
                    $0.leading.equalTo(self.segmentedControl.snp.leading).offset(xPosition)
                }
                self.view.layoutIfNeeded()
            }
        } else {
            selectionIndicator.snp.updateConstraints {
                $0.leading.equalTo(segmentedControl.snp.leading).offset(xPosition)
            }
        }
    }
    
    private func updateViewController() {
        // 기존 VC 제거
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let currentVC = currentViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // 선택된 세그먼트에 따라 VC 결정
        let selectedVC: UIViewController
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedVC = movieListVC
        case 1:
            selectedVC = searchVC
        case 2:
            selectedVC = myPageVC
        default:
            selectedVC = movieListVC
        }
        
        // 새 VC 추가
        addChild(selectedVC)
        selectedVC.view.frame = containerView.bounds
        containerView.addSubview(selectedVC.view)
        selectedVC.didMove(toParent: self)
        
        // 현재 VC 업데이트
        currentViewController = selectedVC
        CATransaction.commit()
    }
    
    // MARK: - User Info Handling
    
    private func loadUserInfo() {
        // 추후 UserService로 이동 가능한 로직
        if let currentUser = UserService.shared.getCurrentUser() {
             welcomeUser.text = "\(currentUser.userId)님 반갑습니다."
        }
    }
}
