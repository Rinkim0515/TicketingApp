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
    // seg값에 따라서 검색요청 방식을 다르게 진행하자
    //seg 가 0 인경우 -> 전체 영화 로드 후 reloadSection
    //seg 1인경우 검색 누르기 전까지 뭐 없음 허나 검색버튼 누를시 검색 호출 진행
    
    @Published var searchMode: SearchMode = .nowPlayingOnly
    @Published private(set) var searchResults: [Movie] = []
    
    private(set) var nowplayingMovies: [Movie] = []
    
    
    
    private let repository = MovieRepository.shared
    private var currentQuery: String = ""
    
    private var currentPage: Int = 1
    private var isLoadingMore = false
    
    @Published var isSearching: Bool = false // Debounce의 목적
    
    private var isLoading = false
    
    
    private var totalPages: Int?

    
    func search(query: String) async {
        currentQuery = query
        currentPage = 1
        
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }

        switch searchMode {
        case .all:
            await performSearch(page: 1)
        case .nowPlayingOnly:
            filterNowPlayingMovies(query: query)
        }
        
    }
    
    private func performSearch(page: Int, append: Bool = false) async {
        isSearching = true
        let result = await repository.fetchSearchMovies(query: currentQuery, page: page)

        switch result {
        case .success(let info):
            if append {
                self.searchResults += info.movies
            } else {
                self.searchResults = info.movies
            }
        case .failure:
            if !append {
                self.searchResults = []
            }
        }
        isSearching = false
    }

    // 상영중영화에서 필터링 기반의 검색을 위한 메서드
    private func filterNowPlayingMovies(query: String) {
        let lowercasedQuery = query.lowercased()
        let filtered = nowplayingMovies.filter { $0.title.lowercased().contains(lowercasedQuery) }
        self.searchResults = filtered
    }
    
    //
    func loadMoreSearchResults() async {
        
        guard !currentQuery.isEmpty,
              !isLoadingMore,
              let totalPages = totalPages,
              currentPage < totalPages else { return }

        isLoadingMore = true
        currentPage += 1
        await performSearch(page: currentPage, append: true)
        isLoadingMore = false

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
