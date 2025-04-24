//
//  MovieHeaderView.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
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
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-4)
        }
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
