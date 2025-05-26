//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 250519

import Foundation
import Combine

struct MovieState {
    let type: MovieCategory
    var totalData: Int
    var movies : [Movie]
    var currentPage: Int
    var isloading: Bool
    var totalPages: Int
}

final class MovieListViewModel {
    
    private enum Constants {
        static let initialPage = 1
    }
    
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []
    
    private var domainMovieData: [MovieCategory: [Movie]] = [:]
    private let loadingState = MovieLoadingTracker()
    private var currentPageByCategory: [MovieCategory: Int] = [
        .nowPlaying: Constants.initialPage,
        .upcoming: Constants.initialPage,
        .popular: Constants.initialPage
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
        await loadMovies(for: category)
    }
    
    private func loadMovies(for type: MovieCategory) async {
        let page = currentPageByCategory[type, default: Constants.initialPage]
        guard await loadingState.checkAndSetLoading(for: type) else {
            return
        }
        
        let result = await repository.fetchMovies(by: type, page: page)
        await MainActor.run {
            switch result {
            case .success(let info):
                appendMoviesToPublishedModels(info.movies, for: type)
                currentPageByCategory[type] = info.currentPage + 1
                totalPagesByCategory[type] = info.totalPages
            case .failure(let error):
                handleLoadingError(error, for: type)
            }
        }
        
        await loadingState.setFinished(for: type)
        print("🏁 LOAD COMPLETE: \(type), page \(page)")
    }
    
    private func handleLoadingError(_ error: Error, for type: MovieCategory) {
        print("❌ LOAD ERROR: \(type) - \(error.localizedDescription)")
        // TODO: 에러 상태를 UI에 전달하는 로직 추가 예정
    }
    
    @MainActor
    private func appendMoviesToPublishedModels(_ newMovies: [Movie], for type: MovieCategory) {
        switch type {
        case .upcoming:
            appendUpcomingMovies(newMovies)
        case .nowPlaying:
            appendNowPlayingMovies(newMovies)
        case .popular:
            appendPopularMovies(newMovies)
        }
    }
    
    // MARK: - Private Helper Methods
    @MainActor
    private func appendUpcomingMovies(_ newMovies: [Movie]) {
        let mapped = newMovies.map { MovieUIModelMapper.mapToBannerModel(from: $0, category: .upcoming) }
        upcomingBannerModels += mapped
        upcomingMovies += newMovies
    }
    
    @MainActor
    private func appendNowPlayingMovies(_ newMovies: [Movie]) {
        let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: .nowPlaying, isNowPlaying: true) }
        nowPlayingCardModels += mapped
        nowPlayingMovies += newMovies
    }
    
    @MainActor
    private func appendPopularMovies(_ newMovies: [Movie]) {
        let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: .popular) }
        popularCardModels += mapped
        popularMovies += newMovies
    }
    
    
    
    func currentPage(for category: MovieCategory) -> Int {
        return currentPageByCategory[category] ?? Constants.initialPage
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
        return currentPageByCategory[category, default: Constants.initialPage] <= total
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
