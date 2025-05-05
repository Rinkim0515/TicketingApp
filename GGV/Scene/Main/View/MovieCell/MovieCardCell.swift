//
//  MovieCardCell.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieCardCell: UICollectionViewCell, ReusableView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        titleLabel.font = .boldSystemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.5) // 포스터 비율
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configure(with model: MovieListModel) {
        if let posterPath = model.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
        
        titleLabel.text = model.title
    }
}
