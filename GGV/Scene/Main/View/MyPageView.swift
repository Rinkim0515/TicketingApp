//
//  MyPageView.swift
//  TeamOne1
//
//  Created by 내꺼다 on 7/25/24.
//

import Foundation
import UIKit

// MARK: 마이 페이지에 들어갈 CollectionView Cell
class MyPageCollectionViewCell: UICollectionViewCell {
    
    // 마이페이지 컬렉션 뷰 셀에 들어갈 UI 설정
    // 포스터 이미지
    let posterImageView = UIImageView()
        
    // 영화 이름
    let movieLabel = UILabel()
    
    // 영화 상영 날짜
    let movieDate: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 영화 상영 시간
    let movieTime: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 영화 티켓 구매 인원수
    let peopleCount: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 가격
    let moviePrice: UILabel = {
        let label = UILabel()
        label.text = "14000 원"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 레이아웃 설정
        [posterImageView, movieLabel, movieDate, movieTime, peopleCount, moviePrice].forEach { contentView.addSubview($0) }
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 15
        posterImageView.image = UIImage(named: "city")
        
        movieLabel.textAlignment = .center
        movieLabel.font = UIFont.systemFont(ofSize: 12)
        movieLabel.numberOfLines = 2
        movieLabel.text = "범죄도시4"
        
        setUpCellUI()
    }
    
    func configure2(temp: [String: Any]) {
        
        movieLabel.text = temp["movieTitle"] as? String
        movieDate.text = temp["date"] as? String
        movieTime.text = temp["time"] as? String
               
        if let people = temp["people"] as? Int {
            peopleCount.text = "\(people)명"
        }

        if let price = temp["price"] as? Int {
            moviePrice.text = "\(price)원"
        }
        
        if let posterPath = temp["posterPath"] as? String {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = nil
        }
        
    }
    private func setUpCellUI() {
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(170)
            $0.width.equalTo(120)
        }
        
        movieLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(posterImageView)
        }
        
        movieDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        movieTime.snp.makeConstraints {
            $0.top.equalTo(movieDate.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        peopleCount.snp.makeConstraints {
            $0.top.equalTo(movieTime.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        moviePrice.snp.makeConstraints {
            $0.top.equalTo(peopleCount.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

