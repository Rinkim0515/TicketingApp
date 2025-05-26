//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
// 250519

import Foundation
import Combine



final class MovieListViewModel {
    
    struct MovieState {
        let type: MovieCategory
        var totalData: Int
        var movies : [Movie]
        var currentPage: Int
        var isLoading: Bool
        var totalPages: Int
        
        mutating func updateWithNewMovies(_ info: MovieListInfo) {
            self.movies.append(contentsOf: info.movies)
            self.currentPage = info.currentPage + 1
            self.totalPages = info.totalPages ?? 1
            self.totalData = info.totalResults ?? 1
        }
        
        mutating func setLoading(_ loading: Bool) {
            self.isLoading = loading
        }
    }
    
    private enum Constants {
        static let initialPage = 1
    }
    
    private var movieStates: [MovieCategory: MovieState] = [
        .nowPlaying: MovieState(type: .nowPlaying, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0),
        .upcoming: MovieState(type: .upcoming, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0),
        .popular: MovieState(type: .popular, totalData: 0, movies: [], currentPage: Constants.initialPage, isLoading: false, totalPages: 0)
    ]
    
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []
    
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
        // 1. 상태 체크/설정만 메인스레드
        await MainActor.run {
            guard movieStates[type]?.isLoading != true else { return }
            movieStates[type]?.setLoading(true)
        }
        
        let page = await MainActor.run {
            movieStates[type]?.currentPage ?? 1
        }
        
        // 2. API 호출은 백그라운드 (자동으로 백그라운드에서 실행됨)
        let result = await repository.fetchMovies(by: type, page: page)
        
        // 3. 결과 처리는 다시 메인스레드
        await MainActor.run {
            switch result {
            case .success(let info):
                appendMoviesToPublishedModels(info.movies, for: type)
                movieStates[type]?.updateWithNewMovies(info)
            case .failure(let error):
                handleLoadingError(error, for: type)
            }
            movieStates[type]?.setLoading(false)
        }
        
        print("🏁 LOAD COMPLETE: \(type), page \(page)")
    }
    

    @MainActor
    private func shouldStartLoading(for type: MovieCategory) -> Bool {
        guard movieStates[type]?.isLoading != true else { return false }
        movieStates[type]?.setLoading(true)
        return true
    }
    
    
    @MainActor
    func getMovieState(for category: MovieCategory) -> MovieState? {
        return movieStates[category]
    }
    
    func isLoadingState(for category: MovieCategory) -> Bool {
        return movieStates[category]?.isLoading ?? false
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
    }
    
    @MainActor
    private func appendNowPlayingMovies(_ newMovies: [Movie]) {
        let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: .nowPlaying, isNowPlaying: true) }
        nowPlayingCardModels += mapped
    }
    
    @MainActor
    private func appendPopularMovies(_ newMovies: [Movie]) {
        let mapped = newMovies.map { MovieUIModelMapper.mapToCardModel(from: $0, category: .popular) }
        popularCardModels += mapped
    }
    
    
    @MainActor
    func currentPage(for category: MovieCategory) -> Int {
        return movieStates[category]?.currentPage ?? Constants.initialPage
    }
    
    private func movies(for section: MovieCategory) -> [Movie] {
        return movieStates[section]?.movies ?? []
    }
    
    func shouldLoadMore(for category: MovieCategory) -> Bool {
        guard let state = movieStates[category] else { return false }
        return state.currentPage <= state.totalPages
    }
    
    
}



