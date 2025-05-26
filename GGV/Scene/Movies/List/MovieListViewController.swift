//
//  MovieListViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.
// 250519

import UIKit
import SnapKit
import Combine

final class MovieListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = makeCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        return collectionView
    }()
    
    private let viewModel: MovieListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<MovieCategory, MovieListItem>?
    
    init(viewModel: MovieListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        bindViewModel()
        Task {
            await viewModel.loadInitialSections()
        }
    }
    
    deinit {
        print("👍 \(String(describing: type(of: self))) deinit")
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setupCollectionView() {
        setupDataSource()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            
            $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieCategory, MovieListItem>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .banner(let model):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath) as? BannerCell {
                    cell.configure(with: model)
                    return cell
                }
                return UICollectionViewCell()
            case .card(let model):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.id, for: indexPath) as? MovieCardCell {
                    cell.configure(with: model)
                    return cell
                }
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath) as? HeaderView
            else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0: header.setTitle("상영 예정 영화")
            case 1: header.setTitle("현재 상영 영화")
            case 2: header.setTitle("인기 영화")
            default: break
            }
            return header
        }
        collectionView.dataSource = dataSource
    }
    
    private func bindViewModel() {
        Publishers.CombineLatest3(viewModel.$nowPlayingCardModels, viewModel.$upcomingBannerModels, viewModel.$popularCardModels)
            .map { [weak self] nowPlaying, upcoming, popular -> (nowPlayingItems: [MovieListItem], upcomingItems: [MovieListItem], popularItems: [MovieListItem])? in
                guard self != nil else { return nil }
                
                let nowPlayingItems = nowPlaying.map { MovieListItem.card($0) }
                let upcomingItems = upcoming.map { MovieListItem.banner($0) }
                let popularItems = popular.map { MovieListItem.card($0) }
                return (nowPlayingItems, upcomingItems, popularItems)
            }
            .compactMap { $0 } // nil 값 필터링
            .receive(on: DispatchQueue.main) // RunLoop 대신 DispatchQueue 사용 (
            .sink { [weak self] tuple in
                let snapshot = self?.viewModel.applySnapshot(nowPlaying: tuple.nowPlayingItems, upcoming: tuple.upcomingItems, popular: tuple.popularItems)
                self?.dataSource?.apply(snapshot ?? NSDiffableDataSourceSnapshot<MovieCategory, MovieListItem>(), animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
    
}
//MARK: - UICollectionView Delegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let type = MovieCategory(rawValue: indexPath.section) else { return }
        let currentItemsCount: Int
        switch type {
        case .upcoming: currentItemsCount = viewModel.upcomingBannerModels.count
        case .nowPlaying: currentItemsCount = viewModel.nowPlayingCardModels.count
        case .popular: currentItemsCount = viewModel.popularCardModels.count
        }
        //그리려는 셀이 마지막셀이면 추가 데이터 로드 진행
        let isLastItem = indexPath.item == currentItemsCount - 1
        if isLastItem && viewModel.shouldLoadMore(for: type) {
            Task {
                await viewModel.loadNextPageIfNeeded(for: type)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource?.itemIdentifier(for: indexPath) else { return }
        let movieID: Int
        let isNowPlaying: Bool
        
        switch selectedMovie {
        case .banner(let model):
            print(model.movieId)
            movieID = model.movieId
            isNowPlaying = false
        case .card(let model):
            movieID = model.movieId
            isNowPlaying = model.isNowPlaying
        }
        
        let detailVC = MovieDetailViewController(movieId: movieID, isNowPlaying: isNowPlaying)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
