//
//  SerachVM.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
//

import Foundation

final class SerachVM {
    private var isLoaded: Bool = false
    private var isLoading: Bool = false
    private var nowplayinResult: [Movie] = []
    @Published var nowPlayingMovies : [MovieSearchCellModel] = []
    
    private let repository = MovieRepository.shared
    
    func loadNowplaying() async {
        isLoading = true
        nowplayinResult = []
        // 유효하게 호출할수있는지 페이지 1을 먼저 호출
        guard let (totalPages, firstPageMovies) = await fetchFirstPage() else {
            isLoading = false
            return
        }
        // 그후 병렬적으로 모든 데이터 호출
        let otherPagesMovies = await fetchRemainingPages(totalPages: totalPages)

        self.nowplayinResult = firstPageMovies + otherPagesMovies
        
        isLoading = false
    }
    
    // 1페이지를 호출 + 데이터의 총갯수, 페이지가 몇번까지 있는지 반환
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
