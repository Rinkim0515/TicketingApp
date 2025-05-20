//
//  TabBarController.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//
import UIKit

final class TabBarController: UIViewController {
    // MARK: - Properties
    private var viewControllers: [UIViewController] = []
    private var selectedIndex: Int = 0
    // MARK: - UI Components
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
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 13)
        return label
    }()
    
    private lazy var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
        tabBar.clipsToBounds = false
        
        // 탭바 배경색 설정
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        
        // 탭바 그림자 설정
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        tabBar.layer.shadowRadius = 6
        return tabBar
    }()
    
    private lazy var selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1.5
        view.clipsToBounds = true
        return view
    }()
    // MARK: - Lifecycle Methods
    init() {
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
         initializeView()
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: animated)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         navigationController?.setNavigationBarHidden(false, animated: animated)
     }
    // MARK: - Setup Methods
        /// 뷰 초기화 메서드
        private func initializeView() {
            setupLogoView()
            loadUserInfo()
            setupViewControllers()
            setupCustomTabBar()
            setupConstraints()
            setupSelectionIndicator()
            selectViewController(at: 0)
        }
        
        /// 상단 로고 뷰 설정
        private func setupLogoView() {
            view.addSubview(logoView)
            view.addSubview(welcomeUser)
            logoView.addSubview(logoImageView)
            
            logoView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            
            logoImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(15)
                $0.bottom.equalToSuperview().offset(-5)
                $0.height.equalTo(40)
                $0.width.equalTo(55)
            }
            
            welcomeUser.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalTo(logoView.snp.bottom).offset(-10)
            }
        }
    /// 탭바에 표시될 뷰컨트롤러 설정
        private func setupViewControllers() {
            let movieListVC = MovieListViewController(viewModel: MovieListVM())
            let movieListNavVC = UINavigationController(rootViewController: movieListVC)
            movieListNavVC.tabBarItem = UITabBarItem(title: "영화 목록", image: nil, tag: 0)
            
            // 영화 검색 뷰컨트롤러
            let searchVC = NowPlayingSearchViewController(viewModel: NowPlayingSerachViewModel())
            let searchNavVC = UINavigationController(rootViewController: searchVC)
            searchNavVC.tabBarItem = UITabBarItem(title: "영화 검색", image: nil, tag: 1)
            
            // 마이페이지 뷰컨트롤러
            let myPageVC = MyPageViewController()
            let myPageNavVC = UINavigationController(rootViewController: myPageVC)
            myPageNavVC.tabBarItem = UITabBarItem(title: "마이페이지", image: nil, tag: 2)
            
            
            viewControllers = [movieListNavVC, searchNavVC, myPageNavVC]
        }
        
        /// 커스텀 탭바 설정
        private func setupCustomTabBar() {
            tabBar.items = viewControllers.map { $0.tabBarItem }
            tabBar.selectedItem = tabBar.items?.first
            view.addSubview(tabBar)
            
            // 탭바 텍스트 스타일 설정
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "NanumSquareNeo-dEb", size: 18) ?? .systemFont(ofSize: 18),
                .foregroundColor: UIColor.white
            ]
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
            
            // 탭바 텍스트 위치 조정
            let positionAdjustment = UIOffset(horizontal: 0, vertical: -17)
            UITabBarItem.appearance().titlePositionAdjustment = positionAdjustment
        }
        
        /// UI 요소들의 제약조건 설정
        private func setupConstraints() {
            tabBar.snp.makeConstraints {
                $0.top.equalTo(logoView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(55)
            }
        }
    private func setupSelectionIndicator() {
           tabBar.addSubview(selectionIndicator)
           updateSelectionIndicatorPosition()
       }
       
       /// 탭 선택 인디케이터 위치 업데이트
       private func updateSelectionIndicatorPosition() {
           guard let selectedItem = tabBar.selectedItem,
                 let index = tabBar.items?.firstIndex(of: selectedItem) else {
               return
           }
           
           let tabBarWidth = tabBar.bounds.width
           let itemWidth = tabBarWidth / CGFloat(tabBar.items?.count ?? 1)
           let xPosition = itemWidth * CGFloat(index)
           
           selectionIndicator.snp.remakeConstraints {
               $0.bottom.equalTo(tabBar.snp.bottom)
               $0.height.equalTo(3)
               $0.leading.equalTo(tabBar.snp.leading).offset(xPosition)
               $0.width.equalTo(itemWidth)
           }
           view.layoutIfNeeded()
       }
    // MARK: - Tab Management
    /// 지정된 인덱스의 뷰컨트롤러를 표시
    private func selectViewController(at index: Int) {
        guard index >= 0, index < viewControllers.count else { return }
        
        // 모든 자식 뷰컨트롤러 제거
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // 선택된 뷰컨트롤러(네비게이션 컨트롤러) 추가
        let selectedVC = viewControllers[index]
        addChild(selectedVC)
        selectedVC.view.frame = view.bounds
        view.insertSubview(selectedVC.view, belowSubview: tabBar)
        selectedVC.didMove(toParent: self)
        
        selectedVC.view.snp.makeConstraints {
            $0.top.equalTo(tabBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        // 탭바 아이템 선택 상태 업데이트
        selectedIndex = index
        tabBar.selectedItem = tabBar.items?[index]
        updateSelectionIndicatorPosition()
    }
    // MARK: - User Info Handling
    private func loadUserInfo() {
           // 추후 UserService로 이동 가능한 로직
        if let currentUser = UserService.shared.getCurrentUser() {
             welcomeUser.text = "\(currentUser.userId)님 반갑습니다."
         }
    }
}



// MARK: - UITabBarDelegate
extension TabBarController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            selectViewController(at: index)
        }
    }
    

}


