//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {

    // Publisher to emit inserted index paths for compositional layout update
    let insertedIndexPathsPublisher = PassthroughSubject<(MovieRequestType, [IndexPath]), Never>()

    // Exposed for Combine binding
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var popular: [Movie] = []

    
    private var isLoading: [MovieRequestType: Bool] = [
        .nowPlaying: false,
        .upcoming: false,
        .popular: false
    ]
    
    private var currentPage: [MovieRequestType: Int] = [
        .nowPlaying: 1,
        .upcoming: 1,
        .popular: 1
    ]

    private var totalPages: [MovieRequestType: Int] = [:]

    
    private let repository = MovieRepository.shared
    
    
    func fetchAllFromCache() async{
            await loadMoreIfNeeded(for: .nowPlaying)
        await loadMoreIfNeeded(for: .popular)
        await loadMoreIfNeeded(for: .upcoming)
    }
    
    func loadMoreIfNeeded(for section: SectionType) async {
        let requestType: MovieRequestType
        switch section {
        case .nowPlaying: requestType = .nowPlaying
        case .upcoming: requestType = .upcoming
        case .popular: requestType = .popular
        }
        await loadMore(for: requestType)
    }
    
    private func loadMore(for type: MovieRequestType) async {
        if isLoading[type] == true { return }
        if let total = totalPages[type], currentPage[type, default: 1] > total { return }
        
        isLoading[type] = true
        
        let result = await repository.fetchMovies(by: type, page: currentPage[type, default: 1])
        await MainActor.run {
            switch result {
            case .success(let info):
                let insertedIndexPaths = updatePublishedMovies(info.movies, for: type)
                currentPage[type] = info.currentPage + 1
                totalPages[type] = info.totalPages
                insertedIndexPathsPublisher.send((type, insertedIndexPaths))
            case .failure:
                break
                
            }
            isLoading[type] = false
        }
    }
    
    private func updatePublishedMovies(_ newMovies: [Movie], for type: MovieRequestType) -> [IndexPath] {
        let startIndex: Int
        let section: Int
        var insertedPaths: [IndexPath] = []

        switch type {
        case .nowPlaying:
            startIndex = nowPlaying.count
            nowPlaying += newMovies
            section = 0
        case .upcoming:
            startIndex = upcoming.count
            upcoming += newMovies
            section = 1
        case .popular:
            startIndex = popular.count
            popular += newMovies
            section = 2
        }

        let endIndex = startIndex + newMovies.count
        insertedPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: section) }

        return insertedPaths
    }

//    private func loadNowPlaying() async {
//        guard !isLoadingNowPlaying else { return }
//        isLoadingNowPlaying = true
//        let result = await repository.fetchMovies(by: .nowPlaying, page: nowPlayingCurrentPage)
//        await MainActor.run {
//            switch result {
//            case .success(let info):
//                nowPlaying += info.movies
//                nowPlayingCurrentPage = info.currentPage + 1
//                nowPlayingTotalPages = info.totalPages
//            case .failure:
//                break
//            }
//            isLoadingNowPlaying = false
//        }
//        
//    }
    
//    private func loadMoreNowPlaying() async {
//        guard !isLoadingNowPlaying else { return }
//        isLoadingNowPlaying = true
//        await repository.fetchNowplayingMovies(loadMore: true)
//        await MainActor.run {
//            nowPlaying += repository.nowPlayingMovies
//            isLoadingNowPlaying = false
//        }
//
//    }
//
//    private func loadMoreUpcoming() async {
//        guard !isLoadingUpcoming else { return }
//        isLoadingUpcoming = true
//        let newItem = await repository.fetchUpcomingMovies(loadMore: true)
//        await MainActor.run {
//            upcoming += newItem
//            isLoadingUpcoming = false
//        }
//
//    }
//
//    private func loadMorePopular() async {
//        guard !isLoadingPopular else { return }
//        isLoadingPopular = true
//        await repository.fetchPopularMovies(loadMore: true)
//        await MainActor.run {
//            popular += repository.popularMovies
//            isLoadingPopular = false
//        }
//    }
    
}
