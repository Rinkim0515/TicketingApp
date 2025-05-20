//
//  MyPageView.swift
//  TeamOne1
//
//  Created by 내꺼다 on 7/25/24.
//

// 리팩토링된 MyPageCollectionViewCell.swift

import UIKit
import SnapKit
import Kingfisher

/// 마이페이지에서 예약 정보를 표시하는 컬렉션 뷰 셀
final class MyPageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    // 포스터 이미지뷰
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    // 영화 제목 라벨
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    // 영화 상영 날짜
    private lazy var movieDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 영화 상영 시간
    private lazy var movieTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 영화 티켓 구매 인원수
    private lazy var peopleCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // 가격
    private lazy var moviePrice: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // UI 컴포넌트 추가
        [posterImageView, movieLabel, movieDate, movieTime, peopleCount, moviePrice].forEach {
            contentView.addSubview($0)
        }
        
        // 레이아웃 설정
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
    
    // MARK: - Public Configuration Methods
    
    /// Reservation 객체로 셀 구성
    func configure(with reservation: Reservation) {
        movieLabel.text = reservation.movieTitle
        movieDate.text = reservation.date
        movieTime.text = reservation.time
        peopleCount.text = "\(reservation.people)명"
        moviePrice.text = "\(reservation.price)원"
        
        if !reservation.posterPath.isEmpty {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + reservation.posterPath)
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "image_nil"))
        } else {
            posterImageView.image = UIImage(named: "image_nil")
        }
    }
    
    /// 딕셔너리로 셀 구성 (기존 메서드와의 호환성 유지)
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
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "image_nil"))
        } else {
            posterImageView.image = UIImage(named: "image_nil")
        }
    }
    
    /// 셀 재사용 시 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        movieLabel.text = nil
        movieDate.text = nil
        movieTime.text = nil
        peopleCount.text = nil
        moviePrice.text = nil
    }
}
