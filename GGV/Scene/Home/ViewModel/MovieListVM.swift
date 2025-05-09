//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var popular: [Movie] = []
    
    @Published var isLoadingNowPlaying = false
    @Published var isLoadingUpcoming = false
    @Published var isLoadingPopular = false
    

    
    private let repository = MovieRepository.shared
    
    
        func fetchAllFromCache() {
            self.nowPlaying = repository.nowPlayingMovies
            self.popular = repository.popularMovies
            self.upcoming = repository.upcomingMovies
    }
    
    func loadMoreIfNeeded(for section: SectionType) async {
        switch section {
        case .nowPlaying:
            await loadMoreNowPlaying()
        case .upcoming:
            await loadMoreUpcoming()
        case .popular:
            await loadMorePopular()
        }
    }

    private func loadMoreNowPlaying() async {
        guard !isLoadingNowPlaying else { return }
        isLoadingNowPlaying = true
        await repository.fetchNowplayingMovies(loadMore: true)
        await MainActor.run {
            nowPlaying += repository.nowPlayingMovies
            isLoadingNowPlaying = false
        }

    }

    private func loadMoreUpcoming() async {
        guard !isLoadingUpcoming else { return }
        isLoadingUpcoming = true
        let newItem = await repository.fetchUpcomingMovies(loadMore: true)
        await MainActor.run {
            upcoming += newItem
            isLoadingUpcoming = false
        }

    }

    private func loadMorePopular() async {
        guard !isLoadingPopular else { return }
        isLoadingPopular = true
        await repository.fetchPopularMovies(loadMore: true)
        await MainActor.run {
            popular += repository.popularMovies
            isLoadingPopular = false
        }
    }
    
}
