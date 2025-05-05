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
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 15)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.backgroundColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        [
            posterImageView,
            titleLabel,
            statusLabel
        ].forEach { contentView.addSubview($0) }
        
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(statusLabel.snp.leading).offset(-8)
        }
        
        statusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(28)
        }
        
        





    }
    func configure(with movie: Movie, isNowPlaying: Bool) {
        titleLabel.text = movie.title
        statusLabel.text = isNowPlaying ? "예매 가능" : "예매 불가"
        statusLabel.backgroundColor = isNowPlaying ? .systemGreen : .systemRed

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "default_poster") // 기본 이미지 처리
        }

        // 선택적으로 스타일 변경
        titleLabel.backgroundColor = isNowPlaying
            ? UIColor.green.withAlphaComponent(0.5)
            : UIColor.red.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


