//
//  MovieListView.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.
//

import UIKit
import SnapKit

class MovieListView: UIView {
  
  weak var movieListViewController: MovieListViewController?
  lazy var tableView = UITableView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 제약조건 추가
  private func configureUI() {
    
    self.backgroundColor = .white
    addSubview(tableView)
    
    
    tableView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
}
