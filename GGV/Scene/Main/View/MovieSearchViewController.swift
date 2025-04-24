//
//  MovieSearchViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
//
// 애초에 컨셉에 맞게 상영가능한 영화내에서 검색을 하는게 맞다고 생각함

import UIKit
import SnapKit
import Kingfisher

final class MovieSearchViewController: UIViewController {


    let movieSearchView = MovieSearchView() // 무비 서치 뷰
    var movies = [MovieListModel]() // 데이터 저장 배열
    var filteredMoives = [MovieListModel]() // 필터링 된 영화 데이터 저장 배열
    
    var isSearching = false // 검색 상태를 나타내는 변수
    var currentPage = 1 // 현재 페이지 번호
    var isFetchingMovies = false // 데이터를 받아오는 중인지? 확인
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
        // searchBar 설정
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "영화 검색"
        
        // collectionView 설정
        
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        
        // 상영중인 영화 데이터를 가져오는 메서드 선언
        fetchNowPlayingMovies()
        // 상영예정인 영화 테이터를 가져오는 메서드 선언
        // fetchUpcomingMovies()
    }
    
    private func setupSearchView() {
      view.addSubview(movieSearchView)
      movieSearchView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
    // 현재 상영중인 영화 데이터를 가져오는 메서드
    private func fetchNowPlayingMovies() {
        
        guard !isFetchingMovies else { return }
        isFetchingMovies = true
        
        MovieNetwork.shared.fetchNowPlayingMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies.append(contentsOf: movies)
                self?.currentPage += 1
                DispatchQueue.main.async {
                    self?.movieSearchView.movieCollectionView.reloadData()
                }
            case . failure(let error):
                print("Error fetching movies: \(error)")
            }
            self?.isFetchingMovies = false
        }
    }
    
}

extension MovieSearchViewController: UISearchBarDelegate {
    // 검색기능
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMoives = movies
            isSearching = false
        } else {
            filteredMoives = movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            isSearching = true
        }
        movieSearchView.movieCollectionView.reloadData()
    }
}

extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredMoives.count : movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! SearchMovieCollectionViewCell
        let movie = isSearching ? filteredMoives[indexPath.item] : movies[indexPath.item]
        cell.ptTitleLabel.text = movie.title
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.posterImageView.kf.setImage(with: url)
        } else {
            cell.posterImageView.image = UIImage(named: "city")
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // 컬렉션 뷰 스크롤이 끝에 도달하면 다음페이지의 데이터를 가져옴
        if offsetY > contentHeight - height * 2 {
            fetchNowPlayingMovies()
        }
    }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectMovie = isSearching ? filteredMoives[indexPath.item] : movies[indexPath.item]
    let detailVC = MovieDetailViewController()
    detailVC.movie = selectMovie
    navigationController?.pushViewController(detailVC, animated: true)
  }
}


