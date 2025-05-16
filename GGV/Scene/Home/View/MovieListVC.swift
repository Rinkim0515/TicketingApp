//
//  MovieListViewController.swift
//  TeamOne1
//
//  Created by 유민우 on 7/23/24.

//pull to refresh ?
// 상영중인 영화는 순서를 random 하게 해줘도 좋을거 같아 -> 인기순위랑 순서가 겹치는경우가 많아서
// 여기를 compositional layout으로 바꿔줘야함 tableView는 없애고 Header 넣어야함
// SnapShot 이나 Diffiable에 대한것이 overengineering이 될수도 있다는 판단.

import UIKit
import SnapKit
import Combine
import UIKit.UICellConfigurationState

final class MovieListViewController: UIViewController {
    

    
    private var collectionView: UICollectionView!
    private let viewModel: MovieListVM
    private var cancellables = Set<AnyCancellable>() // Disposable 같은 존재
    private var dataSource: UICollectionViewDiffableDataSource<MovieCategory, MovieListItem>!
    
    

    
    init(viewModel: MovieListVM){
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
        

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
        
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white

        collectionView.delegate = self

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)

        dataSource = UICollectionViewDiffableDataSource<MovieCategory, MovieListItem>(collectionView: collectionView) { collectionView, indexPath, item in
            let MovieCategory = MovieCategory.allCases[indexPath.section]
            switch item {
            case .banner(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath) as! BannerCell
                cell.configure(with: model)
                return cell
            case .card(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.id, for: indexPath) as! MovieCardCell
                cell.configure(with: model)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath) as! HeaderView
            switch indexPath.section {
            case 0: header.setTitle("상영 예정 영화")
            case 1: header.setTitle("현재 상영 영화")
            case 2: header.setTitle("인기 영화")
            default: break
            }
            return header
        }

        collectionView.dataSource = dataSource

        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

    }

    
    private func bindViewModel() {
        print("📋 upcomingModels 순서:")

        
        Publishers.CombineLatest3(viewModel.$nowPlayingModels, viewModel.$upcomingModels, viewModel.$popularModels)
        
            .map { nowPlaying, upcoming, popular in
                let nowPlayingItems = nowPlaying.map { MovieListItem.card($0) }
                let upcomingItems = upcoming.map { MovieListItem.banner($0) }
                let popularItems = popular.map { MovieListItem.card($0) }
                return (nowPlayingItems, upcomingItems, popularItems)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] nowPlaying, upcoming, popular in
                self?.applySnapshot(nowPlaying: nowPlaying, upcoming: upcoming, popular: popular)
            }
            .store(in: &cancellables)
        
    }
    
    private func applySnapshot(nowPlaying: [MovieListItem], upcoming: [MovieListItem], popular: [MovieListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<MovieCategory, MovieListItem>()
        snapshot.appendSections(MovieCategory.allCases)
        snapshot.appendItems(upcoming, toSection: .upcoming)
        snapshot.appendItems(nowPlaying, toSection: .nowPlaying)
        snapshot.appendItems(popular, toSection: .popular)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
    

    @MainActor
    private func reload(section: Int) {
        self.collectionView.reloadData()
    }
    
    


 

    
}
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let type = MovieCategory(rawValue: indexPath.section) else { return }
        
        let currentItemsCount: Int
        switch type {
        case .upcoming: currentItemsCount = viewModel.upcomingModels.count
        case .nowPlaying: currentItemsCount = viewModel.nowPlayingModels.count
        case .popular: currentItemsCount = viewModel.popularModels.count
        }
        let isLastItem = indexPath.item == currentItemsCount - 1
        
        if isLastItem && viewModel.hasMorePages(for: type) {
            Task {
                await viewModel.loadMoreIfNeeded(for: type)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource.itemIdentifier(for: indexPath) else { return }
        

        
        let movieID: Int
        let isNowPlaying: Bool
        switch selectedMovie {
        case .banner(let model):
            print(model.id)
            movieID = model.id
            isNowPlaying = false
        case .card(let model):
            movieID = model.id
            isNowPlaying = model.isNowPlaying
        }


        
        let detailVC = MovieDetailViewController(movieId: movieID, isNowPlay: isNowPlaying)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: - Compositional Layout

extension MovieListViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.bannerSection()
            case 1, 2:
                return self.cardSection()
            default:
                return nil
            }
        }
    }

    private func bannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.92),
            heightDimension: .fractionalWidth(0.52) // slightly smaller height
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        // 헤더의 위치조정 필요
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func cardSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(160),
            heightDimension: .absolute(220)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: 1))
        group.interItemSpacing = .fixed(20)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }
}
