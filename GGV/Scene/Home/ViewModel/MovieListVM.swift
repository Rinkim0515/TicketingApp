//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []

    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []

    private let loadingState = MovieLoadingState()
    
    private var currentPage: [MovieCategory: Int] = [
        .nowPlaying: 1,
        .upcoming: 1,
        .popular: 1
    ]
    private var totalPages: [MovieCategory: Int] = [:]
    private let repository = MovieRepository.shared

    func fetchInitialSections() async {
        async let now: () = loadMoreIfNeeded(for: .nowPlaying)
        async let pop: () = loadMoreIfNeeded(for: .popular)
        async let upc: () = loadMoreIfNeeded(for: .upcoming)
        _ = await [now, pop, upc]
    }
    

    
    func loadMoreIfNeeded(for category: MovieCategory) async {
        await loadMore(for: category)
    }
    
    private func loadMore(for type: MovieCategory) async {
        guard await loadingState.checkAndSetLoading(for: type) else { return }
        
        let result = await repository.fetchMovies(by: type, page: currentPage[type, default: 1])
        await MainActor.run {
            switch result {
            case .success(let info):
                print(info.movies.count)
                updatePublishedMovies(info.movies, for: type)
                currentPage[type] = info.currentPage + 1
                totalPages[type] = info.totalPages
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
            upcomingBannerModels += mapped
            upcomingMovies += newMovies
            
        case .nowPlaying:
            let mapped = newMovies.map {
                MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: true)
            }
            nowPlayingCardModels += mapped
            
            nowPlayingMovies += newMovies
            

        case .popular:
            let mapped = newMovies.map {
                MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: false)
            }
            popularCardModels += mapped
            
            popularMovies += newMovies
            
        }


    }
    func currentPage(for category: MovieCategory) -> Int {
        return currentPage[category] ?? 1
    }
    
    private func items(for section: MovieCategory) -> [Movie] {
        switch section {
        case .upcoming: return upcomingMovies
        case .nowPlaying: return nowPlayingMovies
        case .popular: return popularMovies
        }
    }
    
    func hasMorePages(for category: MovieCategory) -> Bool {
        guard let total = totalPages[category] else { return false }
        return currentPage[category, default: 1] <= total
    }


}





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
