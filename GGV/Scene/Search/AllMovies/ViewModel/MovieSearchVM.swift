//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.

import Foundation

@MainActor
final class MovieSearchVM {
    
    enum SearchMode {
        case all
        case nowPlayingOnly
    }
    
    @Published var searchMode: SearchMode = .nowPlayingOnly
    @Published private(set) var searchResults: [Movie] = []
    private(set) var nowplayingMovies: [Movie] = []
    
    private let repository = MovieRepository.shared
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var isLoadingMore = false
    
    private var isLoading = false
    
    func search(query: String) async {
        currentQuery = query
        currentPage = 1
        guard !query.isEmpty else { self.searchResults = []; return }
        

    }
    
    func loadMoreSearchResults() async {
        
        guard !currentQuery.isEmpty, !isLoadingMore else { return }
        isLoadingMore = true
        currentPage += 1
        

    }



}

//MARK: -  상영중영화 호출
extension MovieSearchVM {
    func loadNowplaying() async {
         isLoading = true
        nowplayingMovies = []

        guard let (totalPages, firstPageMovies) = await fetchFirstPage() else {
            isLoading = false
            
            return
        }

        let otherPagesMovies = await fetchRemainingPages(totalPages: totalPages)

        self.nowplayingMovies = firstPageMovies + otherPagesMovies
        isLoading = false
    }
    
    private func fetchFirstPage() async -> (Int, [Movie])? {
        let result = await repository.fetchMovies(by: .nowPlaying, page: 1)
        switch result {
        case .success(let info):
            guard let totalPages = info.totalPages else { return nil }
            return (totalPages, info.movies)
        case .failure:
            return nil
        }
    }

    private func fetchRemainingPages(totalPages: Int) async -> [Movie] {
        var allMovies: [(Int, [Movie])] = []

        await withTaskGroup(of: (Int, [Movie]).self) { group in
            for page in 2...totalPages {
                group.addTask {
                    let result = await self.repository.fetchMovies(by: .nowPlaying, page: page)
                    switch result {
                    case .success(let info):
                        return (page, info.movies)
                    case .failure:
                        return (page, [])
                    }
                }
            }

            for await result in group {
                allMovies.append(result)
            }
        }

        return allMovies.sorted { $0.0 < $1.0 }.flatMap { $0.1 }
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
