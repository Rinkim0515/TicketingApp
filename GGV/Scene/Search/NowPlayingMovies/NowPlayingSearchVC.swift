//
//  SearchVC.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
// 로컬 기반의 검색


import UIKit
import SnapKit
import Kingfisher
import Combine

final class NowPlayingSearchVC: UIViewController {
    private let movieSearchView = SearchView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: NowPlayingSerachVM
    
    //MARK: - lifeCycle
    init(viewModel: NowPlayingSerachVM){ //@MainActor에 대한 부분 찾아봐야함
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

extension NowPlayingSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
}



//MARK: - UICollectionView
extension NowPlayingSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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



