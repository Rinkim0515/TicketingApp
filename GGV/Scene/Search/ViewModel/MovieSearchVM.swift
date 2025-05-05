//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation

@MainActor
final class MovieSearchVM {
    @Published private(set) var searchResults: [Movie] = []
    @Published private(set) var nowPlayingIDs: Set<Int> = []
    private let movieNetwork = MovieNetwork.shared
    
    func search(query: String) async {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
        do {
            let resultRaw = try await movieNetwork.searchMovies(query: query)
            let result = resultRaw.map { Movie(from: $0) }
            self.searchResults = result
        } catch {
            print("영화 검색 실패: \(error.localizedDescription)")
        }
    }
    
    func fetchNowPlayingIDs() async {
        var page = 1
        var allMovies: [MovieListModel] = []
        var hasMore = true
        
        while hasMore {
            do {
                let movies = try await movieNetwork.fetchNowPlayingMovies(page: page)
                if movies.isEmpty {
                    hasMore = false
                } else {
                    allMovies.append(contentsOf: movies)
                    page += 1
                }
            } catch {
                print("로딩 실패: \(error.localizedDescription)")
                hasMore = false
                
            }
            

        }
        self.nowPlayingIDs = Set(allMovies.map {$0.id} )
    }
}
