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
    
//    let refreshControl = UIRefreshControl()
//    let movieListView = MovieListView()
//    
//    let titles = ["-  상영예정 영화 🎥  - ", "-  상영중인 영화 🎥  -", "-  현재 인기순위 🎥  -"] // 각 행의 타이틀 배열
//    
//    var upcomingMovies: [MovieListModel] = []
//    var nowPlayingMovies: [MovieListModel] = []
//    var popularMovies: [MovieListModel] = []
    
    //
    private var collectionView: UICollectionView!
    private let viewModel = MovieListVM()
    
    
    
    
    
    //
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        bindViewModel()
        
        Task {
            await viewModel.fetchAll()
            await MainActor.run {
                self.collectionView.reloadData()
            }
        }
        
    }
        
        
        
        
        
        

    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: "MovieCardCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func bindViewModel() {
        viewModel.onUpdateNowPlaying = { [weak self] in
            Task {
                await MainActor.run {
                    self?.collectionView.reloadData()
                }
            }
        }
        viewModel.onUpdateUpcoming = { [weak self] in
            Task {
                await MainActor.run {
                    self?.collectionView.reloadData()
                }
            }
        }
        viewModel.onUpdatePopular = { [weak self] in
            Task {
                await MainActor.run {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    @MainActor
    private func reload(section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //        setupMovieList()
    //
    //        movieListView.tableView.dataSource = self
    //        movieListView.tableView.delegate = self
    //
    //        // pull to refresh
    //        let refreshAction = UIAction { [weak self] _ in
    //            guard let self = self else { return }
    //            Task {
    //                await self.loadMovies()
    //                await MainActor.run {
    //                    self.movieListView.tableView.reloadData()
    //                    self.refreshControl.endRefreshing()
    //                }
    //            }
    //        }
    //        refreshControl.addAction(refreshAction, for: .valueChanged)
    //        movieListView.tableView.refreshControl = refreshControl
    //
    //
    //
    //        movieListView.tableView.register(MvListTableViewCell.self, forCellReuseIdentifier: MvListTableViewCell.id)
    //
    //        Task {
    //            await loadMovies()
    //
    //        }
    //    }
//    @MainActor
//    private func loadMovies() async {
//        // 병렬로 호출은 맞음
//        async let upcomingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming")
//        
//        async let nowPlayingMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing")
//        
//        async let popularMovies = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular")
//        
//        self.upcomingMovies = await upcomingMovies
//        self.nowPlayingMovies = await nowPlayingMovies
//        self.popularMovies = await popularMovies
//        movieListView.tableView.reloadData()
//    }
//    
//    
//    private func setupMovieList() {
//        view.addSubview(movieListView)
//        movieListView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//    
    func showMovieDetail(with movie: MovieListModel) {
        let detail = MovieDetailViewController()
        detail.movie = movie
        navigationController?.pushViewController(detail, animated: true)
    }
    
}

//extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titles.count // 행 개수 설정
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 커스텀 셀을 dequeue
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MvListTableViewCell.id, for: indexPath) as? MvListTableViewCell
//        else { return UITableViewCell() }
//        cell.backgroundColor = .lightGray
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 280 // 셀 높이 조정
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = cell as! MvListTableViewCell
//                cell.titleLabel.text = titles[indexPath.row] // 타이틀 설정
//                cell.movieListViewController = self
//                cell.selectionStyle = .none
//        switch indexPath.row {
//        case 0:
//            cell.updateCollectionView(with: upcomingMovies)
//        case 1:
//            cell.updateCollectionView(with: nowPlayingMovies)
//        case 2:
//            cell.updateCollectionView(with: popularMovies)
//        default:
//            break
//            // 어쩐지 이상하다 했음 지금 테이블뷰안에 컬렉션뷰가 있음 이걸 compositional layout으로 바꾸면 될듯
//        }
//    }
//}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.nowPlaying.count
        case 1: return viewModel.upcoming.count
        case 2: return viewModel.popular.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configure(with: viewModel.nowPlaying[indexPath.item])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
            cell.configure(with: viewModel.upcoming[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCardCell", for: indexPath) as! MovieCardCell
            cell.configure(with: viewModel.popular[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        switch indexPath.section {
        case 1: header.setTitle("- 상영 예정 영화 🎬 -")
        case 2: header.setTitle("- 인기 영화 🎬 -")
        default: break
        }
        return header
    }
}


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
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.56) // 16:9
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)

        return section
    }

    private func cardSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)

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
