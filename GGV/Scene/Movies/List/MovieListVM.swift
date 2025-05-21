//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 250519

import Foundation
import Combine

final class MovieListVM {
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []
    
    private let loadingState = MovieLoadingTracker()
    private var currentPageByCategory: [MovieCategory: Int] = [
        .nowPlaying: 1,
        .upcoming: 1,
        .popular: 1
    ]
    private var totalPagesByCategory: [MovieCategory: Int] = [:]
    private let repository = MovieService.shared
    
    func loadInitialSections() async {
        async let now: () = loadNextPageIfNeeded(for: .nowPlaying)
        async let pop: () = loadNextPageIfNeeded(for: .popular)
        async let upc: () = loadNextPageIfNeeded(for: .upcoming)
        _ = await [now, pop, upc]
    }
    
    func loadNextPageIfNeeded(for category: MovieCategory) async {
        let page = currentPageByCategory[category, default: 1]
        
        await loadMovies(for: category)
    }
    
    private func loadMovies(for type: MovieCategory) async {
        let page = currentPageByCategory[type, default: 1]
        
        
        guard await loadingState.checkAndSetLoading(for: type) else {
        
            return
        }
        
        let result = await repository.fetchMovies(by: type, page: page)
        await MainActor.run {
            switch result {
            case .success(let info):
          
                
                // ID 로깅 추가
                let movieIds = info.movies.map { $0.id }
          
                
                appendMoviesToPublishedModels(info.movies, for: type)
                currentPageByCategory[type] = info.currentPage + 1
                totalPagesByCategory[type] = info.totalPages
            case .failure(let error):
                
                break
            }
        }
        
        await loadingState.setFinished(for: type)
        print("🏁 LOAD COMPLETE: \(type), page \(page)")
    }
    
    @MainActor
    private func appendMoviesToPublishedModels(_ newMovies: [Movie], for type: MovieCategory) {
        switch type {
        case .upcoming:
            let mapped = newMovies.map { MovieUIModelMapper.mapToBannerModel(from: $0, category: type) }
            upcomingBannerModels += mapped
            upcomingMovies += newMovies
        case .nowPlaying:
            let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: type, isNowPlaying: true) }
            nowPlayingCardModels += mapped
            nowPlayingMovies += newMovies
        case .popular:
            let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: type) }
            popularCardModels += mapped
            popularMovies += newMovies
        }
        
        
    }
    func currentPage(for category: MovieCategory) -> Int {
        return currentPageByCategory[category] ?? 1
    }
    private func movies(for section: MovieCategory) -> [Movie] {
        switch section {
        case .upcoming: return upcomingMovies
        case .nowPlaying: return nowPlayingMovies
        case .popular: return popularMovies
        }
    }
    func shouldLoadMore(for category: MovieCategory) -> Bool {
        guard let total = totalPagesByCategory[category] else { return false }
        return currentPageByCategory[category, default: 1] <= total
    }
    
    
}





actor MovieLoadingTracker {
    private var isLoading: [MovieCategory: Bool] = [:]
    private var currentPage: [MovieCategory: Int] = [:]
    
    func checkAndSetLoading(for type: MovieCategory) -> Bool {
        if isLoading[type] == true { return false }
        isLoading[type] = true
        return true
    }
    
    func checkAndSetLoading(for type: MovieCategory, page: Int) -> Bool {
        // 이미 로딩 중이거나 같은 페이지를 로드하려는 경우 방지
        if isLoading[type] == true || currentPage[type] == page {
            return false
        }
        isLoading[type] = true
        currentPage[type] = page
        return true
    }
    
    func setFinished(for type: MovieCategory) {
        isLoading[type] = false
    }
}
