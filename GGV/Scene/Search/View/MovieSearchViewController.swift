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
import Combine

final class MovieSearchViewController: UIViewController {
    let movieSearchView = MovieSearchView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MovieSearchVM
    //MARK: - lifeCycle
    init(viewModel: MovieSearchVM){ //@MainActor에 대한 부분 찾아봐야함
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "영화 검색"
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.id)
        bindViewModel()
        Task {
            await viewModel.fetchNowPlayingIDs()
        }
    }
    
    private func bindViewModel() {
        viewModel.$searchResults
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.movieSearchView.movieCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupSearchView() {
        view.addSubview(movieSearchView)
        movieSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - UISearchBar
extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        Task {
            await viewModel.search(query: query)
        }
    }
}

//MARK: - CollectionView
extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.id, for: indexPath) as! SearchMovieCell
        let movie = viewModel.searchResults[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.searchResults[indexPath.item]
        let detailVC = MovieDetailViewController()
        
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // 콘텐츠 높이보다 화면이 큰 경우는 제외하고 조건 재설정
        if contentHeight > height && offsetY > contentHeight - height * 1.5 {
            print("📦 loadMore 조건 만족")
            Task {
                await viewModel.loadMoreSearchResults()
            }
        }
    }
}


