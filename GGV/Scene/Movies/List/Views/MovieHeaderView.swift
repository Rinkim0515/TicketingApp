//
//  MovieHeaderView.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView, ReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.nanumSquare(size: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-4)
        }
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
