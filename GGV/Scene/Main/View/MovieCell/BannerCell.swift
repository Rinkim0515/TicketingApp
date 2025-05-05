//
//  BannerCell.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 헤더셀

import UIKit
import SnapKit
import Kingfisher

final class BannerCell: UICollectionViewCell, ReusableView {
    private let imageView = UIImageView()
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
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalToSuperview()
        }
    }

    func configure(with model: MovieListModel) {
        
        if let backdropPath = model.backdropPath
          {
            let url = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            imageView.kf.setImage(with: url)
            self.titleLabel.text = model.title
        } else {
            imageView.image = nil
        }
    }
}
