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

final class MovieListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: MovieListVM
    private var cancellables = Set<AnyCancellable>() // Disposable 같은 존재

    
    
    
    init(viewModel: MovieListVM = MovieListVM()){
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
            await viewModel.fetchAll()
        }
    }
        
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.id)
        collectionView.register(MovieCardCell.self, forCellWithReuseIdentifier: MovieCardCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

    }
    
    private func bindViewModel() {
        Publishers.CombineLatest3(
            viewModel.$nowPlaying,
            viewModel.$upcoming,
            viewModel.$popular
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] _, _, _ in
            self?.collectionView.reloadData()
        }
        .store(in: &cancellables)
        

    }
    

    @MainActor
    private func reload(section: Int) {
        self.collectionView.reloadData()
    }
    

 

    
}
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = SectionType(rawValue: indexPath.section) else { return }
        
        var selectedMovie: Movie
        switch type {
        case .nowPlaying:
            selectedMovie = viewModel.nowPlaying[indexPath.row]
        case .upcoming:
            selectedMovie = viewModel.upcoming[indexPath.row]
        case .popular:
            selectedMovie = viewModel.popular[indexPath.row]
        }
        selectedMovie.isNowPlaying = true
        let detailVC = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}



extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else { return 0 }
        switch type {
        case .nowPlaying: return viewModel.nowPlaying.count
        case .upcoming: return viewModel.upcoming.count
        case .popular: return viewModel.popular.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath) as! BannerCell
            cell.configure(with: viewModel.nowPlaying[indexPath.item])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.id, for: indexPath) as! MovieCardCell
            cell.configure(with: viewModel.upcoming[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCardCell.id, for: indexPath) as! MovieCardCell
            cell.configure(with: viewModel.popular[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        switch indexPath.section {
        case 0: header.setTitle("현재 상영 영화")
        case 1: header.setTitle("상영 예정 영화")
        case 2: header.setTitle("인기 영화")
        default: break
        }
        return header
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
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.56) // 16:9
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
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
