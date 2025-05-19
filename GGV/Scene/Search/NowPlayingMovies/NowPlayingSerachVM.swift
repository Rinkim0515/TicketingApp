//
//  SerachVM.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
//

import Foundation

final class NowPlayingSerachVM {
    private var isLoaded: Bool = false
    private var isLoading: Bool = false
    
    private var nowplayinResult: [Movie] = []
    private var movieListInfo: MovieListInfo?
    @Published var nowPlayingMovies : [MovieSearchCellModel] = []
    var searchResultUIModel : SearchResultUIModel?
    
    private let repository = MovieRepository.shared
    
    
    //데이터 전체 호출
    func loadNowplaying() async {
        isLoading = true
        nowplayinResult = []
        // 유효하게 호출할수있는지 페이지 1을 먼저 호출
        guard let info = await fetchFirstPage(),
              let totalPages = info.totalPages,
              let totalResults = info.totalResults else {
            isLoading = false
            return
        }
        
        // 그후 병렬적으로 모든 데이터 호출
        self.movieListInfo = info
        let firstPageMovies = info.movies
        let otherPagesMovies = await fetchRemainingPages(totalPages: totalPages)
        self.nowplayinResult = firstPageMovies + otherPagesMovies
        isLoading = false
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
}
