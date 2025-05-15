//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    private var nowPlaying: [Movie] = []
    private var upcoming: [Movie] = []
    private var popular: [Movie] = []

    @Published var nowPlayingModels: [MovieCardCellModel] = []
    @Published var upcomingModels: [MovieBannerCellModel] = []
    @Published var popularModels: [MovieCardCellModel] = []

    private let loadingState = MovieLoadingState()
    
    private var currentPage: [MovieCategory: Int] = [
        .nowPlaying: 1,
        .upcoming: 1,
        .popular: 1
    ]

    private var totalPages: [MovieCategory: Int] = [:]

    
    private let repository = MovieRepository.shared
    
    /// Register a closure to be called when nowPlaying cache is ready.

    
    func fetchInitialSections() async {
        print(#function)
        async let now: () = ()//loadMoreIfNeeded(for: .nowPlaying)
        async let pop: () = ()//loadMoreIfNeeded(for: .popular)
        async let upc: () = loadMoreIfNeeded(for: .upcoming)
        _ = await [now, pop, upc]
    }
    

    
    func loadMoreIfNeeded(for category: MovieCategory) async {
        await loadMore(for: category)
    }
    
    private func loadMore(for type: MovieCategory) async {
        print("🔵 loadMore 실행: \(type), page: \(currentPage[type, default: 1])")
        guard await loadingState.checkAndSetLoading(for: type) else { return }

        
        let result = await repository.fetchMovies(by: type, page: currentPage[type, default: 1])
        await MainActor.run {
            switch result {
            case .success(let info):
//                print(info.currentPage, info.totalPages, info.totalResults)
                print(info.movies.count)
                updatePublishedMovies(info.movies, for: type)
//                let insertedIndexPaths = updatePublishedMovies(info.movies, for: type)
                currentPage[type] = info.currentPage + 1
                totalPages[type] = info.totalPages
                
//                insertedIndexPathsPublisher.send((type, insertedIndexPaths))
            case .failure:
                break
                
            }
        }
            await loadingState.setFinished(for: type)
        }
    
    
    private func updatePublishedMovies(_ newMovies: [Movie], for type: MovieCategory) {

        switch type {
        case .upcoming:
            let mapped = newMovies.map {
                MovieUIModelMapper.mapToBannerModel(from: $0)
            }
            upcomingModels += mapped
            upcoming += newMovies
            
        case .nowPlaying:
            let mapped = newMovies.map {
                MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: true)
            }
            nowPlayingModels += mapped
            
            nowPlaying += newMovies
            

        case .popular:
            let mapped = newMovies.map {
                MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: false)
            }
            popularModels += mapped
            
            popular += newMovies
            
        }


    }
    func currentPage(for category: MovieCategory) -> Int {
        return currentPage[category] ?? 1
    }
    
    private func items(for section: MovieCategory) -> [Movie] {
        switch section {
        case .upcoming: return upcoming
        case .nowPlaying: return nowPlaying
        case .popular: return popular
        }
    }
    
    func hasMorePages(for category: MovieCategory) -> Bool {
        guard let total = totalPages[category] else { return false }
        return currentPage[category, default: 1] <= total
    }


}

// MARK: - MovieSectionDataController Integration




actor MovieLoadingState {
    private var isLoading: [MovieCategory: Bool] = [:]

    func checkAndSetLoading(for type: MovieCategory) -> Bool {
        if isLoading[type] == true { return false }
        isLoading[type] = true
        return true
    }

    func setFinished(for type: MovieCategory) {
        isLoading[type] = false
    }
}
