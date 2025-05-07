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
    @Published private(set) var nowPlayingMovies: [MovieListModel] = []
    private let movieNetwork = MovieNetwork.shared
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var isLoadingMore = false
    
    //Search
    func search(query: String) async {
        
        currentQuery = query
        currentPage = 1
        guard !query.isEmpty else { self.searchResults = []; return }
        if nowPlayingIDs.isEmpty { await fetchNowPlayingIDs()   }
        do {
            let resultRaw = try await movieNetwork.searchMovies(query: query, page: currentPage)
            let result = resultRaw.map { dto in
                let isNowPlaying = nowPlayingIDs.contains(dto.id)
                return Movie(from: dto, isNowPlaying: isNowPlaying)
            }
            self.searchResults = result
            print(searchResults)
        } catch {
            print("영화 검색 실패: \(error.localizedDescription)")
        }
    }
    
    func loadMoreSearchResults() async {
        guard !currentQuery.isEmpty, !isLoadingMore else { return }
        isLoadingMore = true
        currentPage += 1

        do {
            let resultRaw = try await movieNetwork.searchMovies(query: currentQuery, page: currentPage)

            let result = resultRaw.map { dto in
                let isNowPlaying = nowPlayingIDs.contains(dto.id)
                return Movie(from: dto, isNowPlaying: isNowPlaying)
            }

            self.searchResults += result
        } catch {
            print("추가 검색 실패: \(error.localizedDescription)")
        }

        isLoadingMore = false
    }

    
    func fetchNowPlayingIDs() async {
        var page = 1
        var allMovies: [MovieListModel] = []
        var hasMore = true
        while hasMore {
            do {
                let movies = try await movieNetwork.fetchMovies(page: page)
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
        
        self.nowPlayingMovies = allMovies
        self.nowPlayingIDs = Set(allMovies.map { $0.id })
    }
}

extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = format
        return df.date(from: self)
    }
}
