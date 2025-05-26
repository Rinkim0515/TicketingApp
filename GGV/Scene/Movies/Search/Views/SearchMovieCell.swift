//
//  SearchMovieCell.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 마지막 검수일: 240519

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
        label.font = UIFont.nanumSquare(size: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        
        label.backgroundColor = UIColor.overlayBlue
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
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
            $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    func configure(with movie: MovieSearchCellModel) {
        titleLabel.text = movie.title
        if let path = movie.backdropPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "image_nil")
        }
    }
}


