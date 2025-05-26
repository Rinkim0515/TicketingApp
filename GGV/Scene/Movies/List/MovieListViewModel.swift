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
    var isLoading: Bool
    var totalPages: Int
}

final class MovieListViewModel {
    
    private enum Constants {
        static let initialPage = 1
    }
    
    private var movieStates: [MovieCategory: MovieState] = [
        .nowPlaying: MovieState(type: .nowPlaying, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0),
        .upcoming: MovieState(type: .upcoming, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0),
        .popular: MovieState(type: .popular, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0)
    ]
    
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []
    
    
    private let loadingState = MovieLoadingTracker()
    private let repository = MovieService.shared
    
    init () {
        
    }
    

    
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
        let page = movieStates[type]?.currentPage ?? Constants.initialPage
        
        guard await loadingState.checkAndSetLoading(for: type) else {
             return
         }
        
        let result = await repository.fetchMovies(by: type, page: page)
        await MainActor.run {
            switch result {
            case .success(let info):
                appendMoviesToPublishedModels(info.movies, for: type)
                updateMovieState(info, for: type)
            case .failure(let error):
                handleLoadingError(error, for: type)
            }
        }
        
        await loadingState.setFinished(for: type)
        print("🏁 LOAD COMPLETE: \(type), page \(page)")
    }

    
    private func updateMovieState(_ info: MovieListInfo, for type: MovieCategory) {
        guard var state = movieStates[type] else { return }
        
        state.movies.append(contentsOf: info.movies)
        state.currentPage = info.currentPage + 1
        state.totalPages = info.totalPages ?? Constants.initialPage
        state.totalData = info.totalResults ?? Constants.initialPage
        
        movieStates[type] = state
    }
    
    //new
    // MARK: - State Access Methods (New)
    func getMovieState(for category: MovieCategory) -> MovieState? {
        return movieStates[category]
    }
    
    func isLoadingState(for category: MovieCategory) -> Bool {
        return movieStates[category]?.isLoading ?? false
    }
    //

    

    
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
    
    
    // 페이지 관리
    func currentPage(for category: MovieCategory) -> Int {
        return movieStates[category]?.currentPage ?? Constants.initialPage
    }
    
    private func movies(for section: MovieCategory) -> [Movie] {
        switch section {
        case .upcoming: return upcomingMovies
        case .nowPlaying: return nowPlayingMovies
        case .popular: return popularMovies
        }
    }
    
    func shouldLoadMore(for category: MovieCategory) -> Bool {
        guard let state = movieStates[category] else { return false }
        return state.currentPage <= state.totalPages
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

// 상태 관리
extension MovieListViewModel {
    
}
