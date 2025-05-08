//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    @Published var isLoading: Bool = false // 데이터 플래그
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var popular: [Movie] = []
    private let repository = MovieRepository.shared
    func fetchAll() async {
        isLoading = true
        
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.repository.fetchNowplayingMovies() }
            group.addTask { await self.repository.fetchPopularMovies() }
            group.addTask { await self.repository.fetchUpcommingMovies() }
        }

        self.nowPlaying = repository.nowPlayingMovies
        self.popular = repository.popularMovies
        self.upcoming = repository.upcommingMovies

        
        isLoading = false
    }
}
