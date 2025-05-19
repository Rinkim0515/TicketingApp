//
//  MovieCardCell.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 250519

import UIKit
import SnapKit
import Kingfisher

final class MovieCardCell: UICollectionViewCell, ReusableView {
    private let imageView = UIImageView()
    private let titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        self.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(26)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with model: MovieCardCellModel) {
        if let posterPath = model.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
        titleLabel.text = model.title
    }
}
