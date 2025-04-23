//
//  MovieListViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.


import UIKit
import SnapKit

final class MovieListViewController: UIViewController {
  
  let movieListView = MovieListView()
    let titles = ["-  상영예정 영화 🎥  - ", "-  상영중인 영화 🎥  -", "-  현재 인기순위 🎥  -"] // 각 행의 타이틀 배열
    var upcomingMovies: [MovieListModel] = []
    var nowPlayingMovies: [MovieListModel] = []
    var popularMovies: [MovieListModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMovieList()
    
    movieListView.tableView.dataSource = self
    movieListView.tableView.delegate = self
    
    movieListView.tableView.register(MvListTableViewCell.self, forCellReuseIdentifier: MvListTableViewCell.id)
    
    Task {
      await loadMovies()
      movieListView.tableView.reloadData()
    }
  }
  
  private func loadMovies() async {
          async let upcomingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming", language: "ko-KR")
          async let nowPlayingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing", language: "ko-KR")
          async let popularMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular", language: "ko-KR")
          
          self.upcomingMovies = await upcomingMovies
          self.nowPlayingMovies = await nowPlayingMovies
          self.popularMovies = await popularMovies
      }
  
  
  private func setupMovieList() {
    view.addSubview(movieListView)
    movieListView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
    func showMovieDetail(with movie: MovieListModel) {
        let detail = MovieDetailViewController()
        detail.movie = movie
        navigationController?.pushViewController(detail, animated: true)
      }
  
}
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count // 행 개수 설정
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 커스텀 셀을 dequeue
    let cell = tableView.dequeueReusableCell(withIdentifier: MvListTableViewCell.id, for: indexPath) as! MvListTableViewCell
    cell.titleLabel.text = titles[indexPath.row] // 타이틀 설정
    cell.movieListViewController = self
    cell.selectionStyle = .none
    // 각 행에 맞는 데이터를 전달
    switch indexPath.row {
    case 0:
      cell.updateCollectionView(with: upcomingMovies)
    case 1:
      cell.updateCollectionView(with: nowPlayingMovies)
    case 2:
      cell.updateCollectionView(with: popularMovies)
    default:
      break
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 280 // 셀 높이 조정
  }
}
