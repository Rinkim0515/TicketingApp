//
//  SearchMovieCell.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation
import UIKit

import SnapKit

final class SearchMovieCell: UICollectionViewCell, ReusableView {
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 15)
        label.textColor = .white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        [
            posterImageView,
            titleLabel].forEach { contentView.addSubview($0) }
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }
    }
    func configure(with: SearchMovie, isNowPlaying: Bool) {
        titleLabel.text = isNowPlaying ? "예매 가능" : "상영 종료"

//        if let path = movie.posterPath {
//            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
//            posterImageView.kf.setImage(with: url)
//        } else {
//            posterImageView.image = UIImage(named: "default_poster") // 기본 이미지 처리
//        }

        // 선택적으로 스타일 변경
        titleLabel.backgroundColor = isNowPlaying
            ? UIColor.green.withAlphaComponent(0.5)
            : UIColor.red.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


