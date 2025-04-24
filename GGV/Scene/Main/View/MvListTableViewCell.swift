//
//  MvListTableViewCell.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MvListTableViewCell: UITableViewCell {
  static let id = "MvListTableViewCell"
  
  weak var movieListViewController: MovieListViewController?
  var movies: [MovieListModel] = []
  
  let titleLabel: UILabel = {
    let lb = UILabel()
    lb.font = UIFont(name: "NanumSquareNeo-dEb", size: 27)
    return lb
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 200) // 아이템 높이를 200으로 변경하여 제목을 포함할 수 있게 설정
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MvCollectionViewCell.self, forCellWithReuseIdentifier: MvCollectionViewCell.id)
    collectionView.showsHorizontalScrollIndicator = false // 스크롤바 숨김 설정
    return collectionView
  }()
  
  
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [
      titleLabel,
      collectionView
    ].forEach{contentView.addSubview($0)}
    
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self).offset(10)
      $0.centerX.equalTo(self)
      $0.height.equalTo(40)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.left.right.bottom.equalToSuperview().inset(10)
      $0.height.equalTo(200) // 높이를 고정하여 스크롤 문제가 발생하지 않도록 설정
    }
    

  }
  
  func updateCollectionView(with movies: [MovieListModel]) {
    self.movies = movies
    collectionView.reloadData()
  }
}


extension MvListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MvCollectionViewCell.id, for: indexPath) as! MvCollectionViewCell
    let movie = movies[indexPath.item]
    cell.configure(with: movie)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectMovie = movies[indexPath.item]
    movieListViewController?.showMovieDetail(with: selectMovie)
  }
}

//MARK: TableView 셀 안의 CollectionView
class MvCollectionViewCell: UICollectionViewCell {
    static let id = "MvCollectionViewCell"
    
  let imageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 15
    return iv
  }()
  
  let titleLabel = {
    let lb = UILabel()
    lb.textAlignment = .center
    lb.font = UIFont(name: "NanumSquareNeo-dEb", size: 13)
    lb.numberOfLines = 2
    return lb
  }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        
        
        
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView)
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.equalTo(contentView).offset(5)
            $0.trailing.equalTo(contentView).offset(-5)
            $0.bottom.equalTo(contentView).offset(-5)
        }
    }
    
    func configure(with movie: MovieListModel) {
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
        titleLabel.text = movie.title
    }
}




