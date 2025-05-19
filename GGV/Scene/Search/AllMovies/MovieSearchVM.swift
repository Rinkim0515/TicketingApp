//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//  240519

import Foundation

@MainActor
final class MovieSearchVM {
    
    @Published var searchedMovies: [MovieSearchCellModel] = []
    @Published var isLoading: Bool = false
    @Published var totalResultCount: Int = 0
    
    private var rawSearchResults: [Movie] = []
    var searchQuery: String = ""
    private var currentPage: Int = 1
    private var totalPages: Int?
    
    private let repository = MovieRepository.shared
    
    
    func search(query: String) async {
        searchQuery = query
        currentPage = 1
        rawSearchResults = []
        await fetchFirstSearchPage()
    }
    private func fetchFirstSearchPage() async {
        isLoading = true
        let result = await repository.fetchSearchMovies(query: searchQuery, page: 1)
        searchedMovies = []
        switch result {
        case .success(let info):
            self.rawSearchResults += info.movies
            self.totalPages = info.totalPages
            self.totalResultCount = info.totalResults ?? 0
            let newModels = info.movies.map {
                MovieUIModelMapper.mapToSearchModel(from: $0)
                }
            self.searchedMovies += newModels
            print("DEBUG - 검색 전체 결과 수: \(info.totalResults ?? -1)")
            print("DEBUG - 가져온 영화 개수: \(info.movies.count)")
        case .failure:
            self.rawSearchResults = []
        }
        isLoading = false
    }
    
    func fetchAdditionalSearchResults() async {
        guard !searchQuery.isEmpty,
              !isLoading,
              let totalPages = totalPages,
              currentPage < totalPages else { return }
        isLoading = true
        currentPage += 1
        
        let result = await repository.fetchSearchMovies(query: searchQuery, page: currentPage)
        
        switch result {
        case .success(let info):
            self.rawSearchResults += info.movies
            let newModels = info.movies.map {
                MovieUIModelMapper.mapToSearchModel(from: $0)
                }
            self.searchedMovies += newModels
        case .failure:
            break
        }
        isLoading = false
    }
}



