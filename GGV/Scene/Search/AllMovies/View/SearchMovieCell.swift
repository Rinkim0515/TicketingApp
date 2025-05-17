//
//  SearchMovieCell.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 마지막 검수일: 240506

import Foundation
import UIKit
import SnapKit

final class SearchMovieCell: UICollectionViewCell, ReusableView {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 18)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    //MARK: - lifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.clipsToBounds = true
        [
            posterImageView,
            titleLabel
        ].forEach {
            contentView.addSubview($0)
        }
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(90)
            
        }

    }
    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "default_poster")
        }
    }
}


