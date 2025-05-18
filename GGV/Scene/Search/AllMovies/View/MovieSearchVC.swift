//
//  MovieSearchViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.


import UIKit
import SnapKit
import Kingfisher
import Combine

final class MovieSearchVC: UIViewController {
    private let movieSearchView = SearchView()
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
        
        
        if viewModel.searchMode == .nowPlayingOnly {
            Task {
                await viewModel.loadNowplaying()
            }
        }
    }
    // 검색창이 트리거  -> 여기서 검색에 대한 부분을 전달 해야함 vm한테
    
    
    private func bindViewModel() {

        viewModel.$isSearching
            .receive(on: RunLoop.main)
            .sink { [weak self] isSearching in
                self?.movieSearchView.setLoading(isSearching)
            }
            .store(in: &cancellables)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard viewModel.searchMode == .nowPlayingOnly else { return }
        Task {
            await viewModel.search(query: searchText)
        }
    }
    
    private func configureUI() {
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "영화 검색"
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.id)


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
    
    private func initNowPlayingMovies() async {
        await viewModel.loadNowplaying()
        
    }
    
    @objc private func searchModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.searchMode = .nowPlayingOnly
            movieSearchView.movieCollectionView.reloadData()
        case 1:
            movieSearchView.movieCollectionView.reloadData()
            viewModel.searchMode = .all
            
        default:
            break
        }
        
    }
}

//MARK: - UISearchBar
extension MovieSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
}



//MARK: - UICollectionView
extension MovieSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let detailVC = MovieDetailViewController(movieId: movie.id, isNowPlay: false)
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


