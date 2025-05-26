//
//  BannerCell.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 250519

import UIKit
import SnapKit
import Kingfisher

final class BannerCell: UICollectionViewCell, ReusableView {
    private let imageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.nanumSquare(size: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
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
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
    
    
    private func setupUI() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        self.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalToSuperview()
        }
    }

    func configure(with model: MovieBannerCellModel) {
        self.titleLabel.text = model.title
        if let backdropPath = model.backdropPath
          {
            let url = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
            
        } else if let posterPath = model.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w780" + posterPath)
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFit
        }
    }
}
