//
//  SerachVM.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
//

import Foundation

final class NowPlayingSerachViewModel {
     
    @Published var isLoading: Bool = false
    
    private var nowplayingResult: [Movie] = []
    private var movieListInfo: MovieListInfo?
    @Published var nowPlayingMovies : [MovieSearchCellModel] = []
    @Published var searchResultUIModel : SearchResultUIModel?
    
    private let repository = MovieService.shared
    
    //모든 데이터 호출
    func loadNowplaying() async {
        print("start")
        isLoading = true
        nowplayingResult = []
        try? await Task.sleep(nanoseconds: 500_000_000)
        // 유효하게 호출할수있는지 페이지 1을 먼저 호출
        guard let info = await fetchFirstPage(),
              let totalPages = info.totalPages,
              let totalResults = info.totalResults else {
            // 데이터 로드 실패시
            self.searchResultUIModel = SearchResultUIModel(
                results: [],
                totalCount: 0,
                isEmptyResult: true,
                errorMessage: "검색 결과를 불러오지 못했습니다."
            )
            
            isLoading = false
            return
        }
        
        // 그후 병렬적으로 모든 데이터 호출
        self.movieListInfo = info
        let firstPageMovies = info.movies
        let otherPagesMovies = await fetchRemainingPages(totalPages: totalPages)
        let loadedData = firstPageMovies + otherPagesMovies
        // 데이터 로드 완료시 UI 모델로 가공 작업
        self.nowplayingResult = loadedData
        
        self.searchResultUIModel = transformToSearchResultUIModel(from: loadedData, from: totalResults)
        
        isLoading = false
    }
    
    
    private func transformToSearchResultUIModel(from result: [Movie], from totalResults: Int) -> SearchResultUIModel {
        let cellModels = transformToMovieSearchCellModel(from: result)
        self.nowPlayingMovies = cellModels
        return SearchResultUIModel(
            results: cellModels,
            totalCount: totalResults,
            isEmptyResult: cellModels.isEmpty,
            errorMessage: nil
        )
    }
    
    private func transformToMovieSearchCellModel(from result: [Movie]) -> [MovieSearchCellModel] {
        let cellModels = result.map {
            MovieSearchCellModel(
                id: $0.id,
                title: $0.title,
                posterPath: $0.posterPath,
                backdropPath: $0.backdropPath
            )
        }
        return cellModels
    }
    
    // 1페이지를 호출 + 데이터의 총갯수, 페이지가 몇번까지 있는지 반환
    private func fetchFirstPage() async -> MovieListInfo? {
        let result = await repository.fetchMovies(by: .nowPlaying, page: 1)
        switch result {
        case .success(let info):
            return info
        case .failure:
            return nil
        }
    }
    
    // 2페이지부터 끝페이지 까지 호출
    private func fetchRemainingPages(totalPages: Int) async -> [Movie] {
        var allMovies: [(Int, [Movie])] = []
        // 2페이지 부터 병렬적 호출
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
            // 모든 호출이 올때까지 대기
            for await result in group {
                allMovies.append(result)
            }
        }
        // 페이지 순서에 맞게 sorted
        let sortedMovies = allMovies.sorted { $0.0 < $1.0 }
        let flattenedMovies = sortedMovies.flatMap { $0.1 }
        return flattenedMovies
    }
    
    func filterNowPlayingMovies(query: String) {
        // query가 비었으면 전체 데이터 보여줌
        let filtered: [Movie]
        
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filtered = nowplayingResult
        } else {
            filtered = nowplayingResult.filter {
                $0.title.localizedCaseInsensitiveContains(query)
            }
        }
        
        let cellModels = transformToMovieSearchCellModel(from: filtered)
        
        self.searchResultUIModel = SearchResultUIModel(
            results: cellModels,
            totalCount: filtered.count,
            isEmptyResult: cellModels.isEmpty,
            errorMessage: nil
        )
    }
}
