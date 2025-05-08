//
//  MovieSearchView.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
//

import UIKit
import SnapKit

final class MovieSearchView: UIView {
    let searchBar = UISearchBar()
    let searchButton = UIButton(type: .system)
    var movieCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) - 15, height: UIScreen.main.bounds.height / 6)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["상영 영화", "전체 영화"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]

        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        return segmentedControl
    }()

    //MARK: - lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        [
            searchBar,
            movieCollectionView,
            segmentedControl,
            searchButton
            
        ].forEach { addSubview($0) }
        
        searchButton.setTitle("검색", for: .normal)
        searchBar.backgroundImage = UIImage() // 하단의 구분선 없애기 위한 용도
        movieCollectionView.backgroundColor = .white
        self.backgroundColor = .white
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.leading).offset(-8)
            $0.height.equalTo(50)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }

        movieCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}


