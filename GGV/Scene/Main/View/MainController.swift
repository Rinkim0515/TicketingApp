//
//  MainTabBarViewController.swift
//  TeamOne1
//
//  Created by 내꺼다 on 7/24/24.
// 여기가 전체적인 흐름을 관리하는거 같은데 일단 내용자체의 파악이 우선인거 같음 

import UIKit
import SnapKit


// 이부분은 TabBar 관련 부분 한번 읽어봐야함 
final class MainController: UIViewController {

    private let logoView = UIView()
    private let logoImageView = UIImageView()
    
    private let customTabBar = UITabBar()
    
    private var viewControllers: [UIViewController] = []
    
    private let selectionIndicator = UIView()
    
    private let welcomeUser: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 13)
        return label
    }()
    
    // 생명주기 때문에 viewDidLoad로 해주면 디테일뷰컨에서 백버튼 눌렀을 때 네비게이션 바 노출됨 매번 똑같이 네비게이션 바 안보이는 뷰가 보여야 해서 viewWillAppear 사용
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        
        view.backgroundColor = .white
        
      
      
      
        setupLogoView()
        loadUserInfo()
        setupViewControllers()
        setupCustomTabBar()
        setupConstraints()
        setupSelectionIndicator()
        selectViewController(at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  

    private func setupLogoView() {
        logoView.backgroundColor = .white
        view.addSubview(logoView)
        view.addSubview(welcomeUser)
        
        // 로고 이미지 설정
        logoImageView.image = UIImage(named: "GGV") // 로고 이미지 설정
        logoImageView.contentMode = .scaleAspectFill
        logoView.addSubview(logoImageView)
        
        // 로고 뷰 제약 조건 설정
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50) // 로고 뷰 높이
        }
        
        // 로고 이미지 뷰 제약 조건 설정
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(40)
            $0.width.equalTo(55)
        }
        
        welcomeUser.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(logoView.snp.bottom).offset(-10) // 여백 추가
        }
    }
    
    func loadUserInfo() {
        if let userid = UserDefaults.standard.string(forKey: "loggedInUserID"),
           let userDict = UserDefaults.standard.dictionary(forKey: userid) as? [String: String] {
            welcomeUser.text = "\(userDict["userid"] ?? "아이디")님 반갑습니다."
        }
    }

    private func setupViewControllers() {
        let movieListVC = MovieListViewController()
        let searchVC = MovieSearchViewController()
        let myPageVC = MyPageViewController()

        movieListVC.tabBarItem = UITabBarItem(title: "영화 목록", image: nil, tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: "영화 검색", image: nil, tag: 1)
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: nil, tag: 2)
        
        viewControllers = [movieListVC, searchVC, myPageVC]
    }

    private func setupCustomTabBar() {
        customTabBar.items = viewControllers.map { $0.tabBarItem }
        customTabBar.selectedItem = customTabBar.items?.first
        customTabBar.delegate = self
        customTabBar.tintColor = .white
        customTabBar.unselectedItemTintColor = .white
        customTabBar.clipsToBounds = false

         // 탭바 배경색 설정
         customTabBar.backgroundImage = UIImage()
        customTabBar.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)

        
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOpacity = 0.3
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTabBar.layer.shadowRadius = 6


        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "NanumSquareNeo-dEb", size: 18) ?? .systemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        
        let positionAdjustment = UIOffset(horizontal: 0, vertical: -17) // 수직 위치 조정
        UITabBarItem.appearance().titlePositionAdjustment = positionAdjustment
        
        view.addSubview(customTabBar)
    }

    private func setupConstraints() {

        // 탭바 제약 조건
        customTabBar.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(55)
        }
    }
    
    private func setupSelectionIndicator() {
        selectionIndicator.backgroundColor = .white
        selectionIndicator.layer.cornerRadius = 1.5
        selectionIndicator.clipsToBounds = true
        
        customTabBar.addSubview(selectionIndicator)
        
        updateSelectionIndicatorPosition()
    }

    private func updateSelectionIndicatorPosition() {
        guard let selectedItem = customTabBar.selectedItem, let index = customTabBar.items?.firstIndex(of: selectedItem) else {
            return
        }
        
        let tabBarWidth = customTabBar.bounds.width
        let itemWidth = tabBarWidth / CGFloat(customTabBar.items!.count)
        let xPosition = itemWidth * CGFloat(index)
        
        selectionIndicator.snp.remakeConstraints {
            $0.bottom.equalTo(customTabBar.snp.bottom) // TabBar의 bottom에 맞추기
            $0.height.equalTo(3) // Indicator의 높이
            $0.leading.equalTo(customTabBar.snp.leading).offset(xPosition)
            $0.width.equalTo(itemWidth)
        }
        view.layoutIfNeeded()
    }

    private func selectViewController(at index: Int) {
        for (i, vc) in viewControllers.enumerated() {
            if i == index {
                addChild(vc)
                vc.view.frame = view.bounds
                view.insertSubview(vc.view, belowSubview: customTabBar)
                vc.didMove(toParent: self)
                
                vc.view.snp.makeConstraints {
                    $0.top.equalTo(customTabBar.snp.bottom)
                    $0.leading.trailing.bottom.equalToSuperview()
                  
                }
            } else {
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }
        customTabBar.selectedItem = customTabBar.items?[index]
        updateSelectionIndicatorPosition()
    }
}

extension MainController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            selectViewController(at: index)
        }
    }
}


