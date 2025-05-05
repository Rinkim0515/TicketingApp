//
//  MovieSearchView.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
//

import UIKit
import SnapKit

final class MovieSearchView: UIView {
    
    // 검색 상자
    let searchBar = UISearchBar()
    var movieCollectionView: UICollectionView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        // collectionView 레이아웃 설정
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) - 15, height: UIScreen.main.bounds.height / 6)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        // collectionView 초기화
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        movieCollectionView.backgroundColor = .white
        
        
        [searchBar,movieCollectionView].forEach { addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        movieCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}


