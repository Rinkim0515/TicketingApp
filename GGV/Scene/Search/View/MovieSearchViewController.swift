//
//  MovieSearchViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
// 마지막 검수일 240506


import UIKit
import SnapKit
import Kingfisher
import Combine

final class MovieSearchViewController: UIViewController {
    private let movieSearchView = MovieSearchView()
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
        configureUI()
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        viewModel.$searchResults
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.movieSearchView.movieCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func configureUI() {
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "영화 검색"
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.id)
        movieSearchView.searchButton.addAction(
            UIAction { [weak self] _ in
                self?.startSearch()
            }, for: .touchUpInside)
        view.addSubview(movieSearchView)
        movieSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func startSearch(){
        guard let query = movieSearchView.searchBar.text else { return }
        movieSearchView.movieCollectionView.setContentOffset(.zero, animated: false)
        Task {
            await viewModel.search(query: query)
        }
    }
}

//MARK: - UISearchBar
extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
}

//MARK: - UICollectionView
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
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    //스크롤 감지 -> 데이터 추가 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if contentHeight > height && offsetY > contentHeight - height * 1.5 {
            Task {
                await viewModel.loadMoreSearchResults()
            }
        }
    }
}


