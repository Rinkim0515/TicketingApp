//
//  MovieListViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.

//pull to refresh ?
// 상영중인 영화는 순서를 random 하게 해줘도 좋을거 같아 -> 인기순위랑 순서가 겹치는경우가 많아서
// 여기를 compositional layout으로 바꿔줘야함 tableView는 없애고 Header 넣어야함 

import UIKit
import SnapKit

final class MovieListViewController: UIViewController {
    
    let refreshControl = UIRefreshControl()
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
        
        // pull to refresh
        let refreshAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.loadMovies()
                await MainActor.run {
                    self.movieListView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
        refreshControl.addAction(refreshAction, for: .valueChanged)
        movieListView.tableView.refreshControl = refreshControl
        
        
        
        movieListView.tableView.register(MvListTableViewCell.self, forCellReuseIdentifier: MvListTableViewCell.id)
        
        Task {
            await loadMovies()
            
        }
    }
    private func loadMovies() {
        
    }
    
    @MainActor
    private func loadMovies() async {
        // 병렬로 호출은 맞음
        async let upcomingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming")
        
        async let nowPlayingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing")
        
        async let popularMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular")
        
        self.upcomingMovies = await upcomingMovies
        self.nowPlayingMovies = await nowPlayingMovies
        self.popularMovies = await popularMovies
        movieListView.tableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MvListTableViewCell.id, for: indexPath) as? MvListTableViewCell
        else { return UITableViewCell() }
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280 // 셀 높이 조정
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MvListTableViewCell
                cell.titleLabel.text = titles[indexPath.row] // 타이틀 설정
                cell.movieListViewController = self
                cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.updateCollectionView(with: upcomingMovies)
        case 1:
            cell.updateCollectionView(with: nowPlayingMovies)
        case 2:
            cell.updateCollectionView(with: popularMovies)
        default:
            break
            // 어쩐지 이상하다 했음 지금 테이블뷰안에 컬렉션뷰가 있음 이걸 compositional layout으로 바꾸면 될듯
        }
    }
}
