//
//  MovieSearchViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
// 250519

import UIKit
import SnapKit
import Kingfisher
import Combine

final class MovieSearchViewController: UIViewController {
    private let movieSearchView = SearchView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MovieSearchViewModel
    
    init(viewModel: MovieSearchViewModel){
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
        
        self.view.backgroundColor = .white
        self.title = "전체 영화 검색"
    }
    deinit {
        print("👍 \(String(describing: type(of: self))) deinit")
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$searchedMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.movieSearchView.movieCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$totalResultCount
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                guard let self = self else { return }
                let query = self.viewModel.searchQuery
                guard query != ""  else {
                    self.movieSearchView.searchResultLabel.text = "검색어를 입력해주세요."
                    return
                }
                self.movieSearchView.searchResultLabel.text = "\(query)에 대한 검색결과가 \(count)개 있습니다."
                
            }
            .store(in: &cancellables)
        
        
    }
    
    
    
    private func configureUI() {
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "영화 검색"
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.id)
        movieSearchView.floatingButton.isHidden = true
        
        view.addSubview(movieSearchView)
        movieSearchView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
        return viewModel.searchedMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.id, for: indexPath) as? SearchMovieCell
        else { return UICollectionViewCell() }
        let movie = viewModel.searchedMovies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.searchedMovies[indexPath.item]
        let detailVC = MovieDetailViewController(movieId: movie.id, isNowPlaying: false)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    //스크롤 감지 -> 데이터 추가 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if contentHeight > height && offsetY > contentHeight - height * 1.5 {
            Task {
                await viewModel.fetchAdditionalSearchResults()
            }
        }
    }
}


