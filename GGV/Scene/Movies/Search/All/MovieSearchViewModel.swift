//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//  240519

import Foundation

@MainActor
final class MovieSearchViewModel {
    
    @Published var searchedMovies: [MovieSearchCellModel] = []
    @Published var isLoading: Bool = false
    @Published var totalResultCount: Int = 0
    
    private var rawSearchResults: [Movie] = []
    var searchQuery: String = ""
    private var currentPage: Int = 1
    private var totalPages: Int?
    
    private let repository = MovieService.shared
    
    
    func search(query: String) async {
        searchQuery = query
        currentPage = 1
        rawSearchResults = []
        await fetchFirstSearchPage()
    }
    
    private func fetchFirstSearchPage() async {
        setLoading(true)
        let result = await repository.fetchSearchMovies(query: searchQuery, page: 1)
        
        await MainActor.run {
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

            case .failure:
                self.rawSearchResults = []
            }
            self.isLoading = false
        }
        
    }
    
    func fetchAdditionalSearchResults() async {
        guard !searchQuery.isEmpty,
              !isLoading,
              let totalPages = totalPages,
              currentPage < totalPages else { return }
        setLoading(true)
        
        currentPage += 1
        
        let result = await repository.fetchSearchMovies(query: searchQuery, page: currentPage)
        await MainActor.run {
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
            self.isLoading = false
        }
    }
    
    @MainActor
    private func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}



