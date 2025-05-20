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

final class NowPlayingSearchViewController: UIViewController {
    private let movieSearchView = SearchView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: NowPlayingSerachViewModel
    
    //MARK: - lifeCycle
    init(viewModel: NowPlayingSerachViewModel){ //@MainActor에 대한 부분 찾아봐야함
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
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.nowPlayingMovies.isEmpty {
            Task {
                await viewModel.loadNowplaying()
            }
        }
    }
    deinit {
        print("👍 \(String(describing: type(of: self))) deinit")
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func bindViewModel() {
        viewModel.$searchResultUIModel
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let result else { return }
                self?.movieSearchView.movieCollectionView.reloadData()
                // 예시: 결과 수 출력 (추후 라벨이 있다면 연결 가능)
                print("총 검색 결과 수: \(result.totalCount)")
                if result.isEmptyResult {
                    // 빈 상태 UI 처리 예: 라벨 노출, 뷰 전환 등
                    print("검색 결과 없음")
                }
                if let error = result.errorMessage {
                    // 에러 상태 처리
                    print("에러 발생: \(error)")
                }
            }
            .store(in: &cancellables)
        viewModel.$searchResultUIModel
            .receive(on: RunLoop.main)
            .sink{  [weak self] result in
                guard let result else { return }
                self?.movieSearchView.searchResultLabel.text = "총 \(result.totalCount)개의 상영가능한 영화가 있습니다."
                // 예시: 결과 수 출력 (추후 라벨이 있다면 연결 가능)
                print("총 검색 결과 수: \(result.totalCount)")
                if result.isEmptyResult {
                    // 빈 상태 UI 처리 예: 라벨 노출, 뷰 전환 등
                }
                if result.errorMessage != nil {
                    // 에러 상태 처리
                }
                
            }
        
        
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.movieSearchView.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
    }
    

    
    private func configureUI() {
        movieSearchView.searchBar.delegate = self
        movieSearchView.searchBar.placeholder = "상영중인 영화 검색"
        movieSearchView.movieCollectionView.delegate = self
        movieSearchView.movieCollectionView.dataSource = self
        movieSearchView.movieCollectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.id)
        movieSearchView.floatingButton.addAction(UIAction(handler: { [weak self] _ in
            self?.segueToMovieSearchVC()
        }), for: .touchUpInside)
        
        view.addSubview(movieSearchView)
        movieSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func startSearch() {
        guard let query = movieSearchView.searchBar.text else { return }
        viewModel.filterNowPlayingMovies(query: query)
        self.movieSearchView.searchResultLabel.text = "\(viewModel.searchResultUIModel?.totalCount)"
    }
    
    private func segueToMovieSearchVC() {
        let vc = MovieSearchViewController(viewModel: MovieSearchViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NowPlayingSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        startSearch()
    }
}



//MARK: - UICollectionView
extension NowPlayingSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResultUIModel?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchMovieCell.id, for: indexPath) as? SearchMovieCell,
              let searchResult = viewModel.searchResultUIModel,
              indexPath.item < searchResult.results.count else {
            return UICollectionViewCell() // 기본 셀 반환
        }
        
        let movie = searchResult.results[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchResult = viewModel.searchResultUIModel,
              indexPath.item < searchResult.results.count else {
            return
        }
        
        let movie = searchResult.results[indexPath.item]
        let detailVC = MovieDetailViewController(movieId: movie.id, isNowPlaying: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
 
}



