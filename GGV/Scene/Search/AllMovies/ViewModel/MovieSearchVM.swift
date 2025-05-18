//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.

import Foundation

@MainActor
final class MovieSearchVM {
    
    @Published var searchedMovie: [MovieSearchCellModel] = []
    @Published var isSearching: Bool = false // Debounce의 목적
    @Published var resultCount: Int = 0
    
    private var searchResults: [Movie] = []
    
    private let repository = MovieRepository.shared
    
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var totalPages: Int?
    private var isLoading = false
    
    
    
    
    
    func search(query: String) async {
        if currentPage == 1 {
            await performSearch()
        } else if currentPage > 1 {
            await loadMoreSearchResults()
        }
        
        
    }
    
    //메타 데이터 때문에 초기호출과 추가호출을 나눠줘야함
    private func performSearch() async {
        isSearching = true
        let result = await repository.fetchSearchMovies(query: currentQuery, page: 1)
        
        switch result {
        case .success(let info):
            
            self.searchResults += info.movies
            self.totalPages = info.totalPages
            self.resultCount = info.totalResults ?? 0
            
        case .failure:
            
            self.searchResults = []
            
        }
        isSearching = false
    }
    
    func loadMoreSearchResults() async {
        
        guard !currentQuery.isEmpty,
              !isLoading,
              let totalPages = totalPages,
              currentPage < totalPages else { return }
        isLoading = true
        currentPage += 1
        let result = await repository.fetchSearchMovies(query: currentQuery, page: currentPage)
        isLoading = false
        
    }
    
    
    
    
}

//MARK: -  상영중영화 호출


extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = format
        return df.date(from: self)
    }
}
