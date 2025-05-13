//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {

    static var instanceCount = 0
    // Publisher to emit inserted index paths for compositional layout update
    let insertedIndexPathsPublisher = PassthroughSubject<(MovieRequestType, [IndexPath]), Never>()

    // Exposed for Combine binding
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var popular: [Movie] = []

    private let loadingState = MovieLoadingState()
    
    private var currentPage: [MovieRequestType: Int] = [
        .nowPlaying: 1,
        .upcoming: 1,
        .popular: 1
    ]

    init(){
        Self.instanceCount += 1
        print("🧩 MovieListVM init 진입 (총 인스턴스 수: \(Self.instanceCount))")
    }
    private var totalPages: [MovieRequestType: Int] = [:]

    
    private let repository = MovieRepository.shared
    
    
    func fetchAllFromCache() async{
        print("🟢 fetchAllFromCache 진입")
            await loadMoreIfNeeded(for: .nowPlaying)
        await loadMoreIfNeeded(for: .popular)
        await loadMoreIfNeeded(for: .upcoming)
    }
    
    func loadMoreIfNeeded(for section: SectionType) async {
        let requestType: MovieRequestType
        switch section {
        case .nowPlaying: requestType = .nowPlaying
        case .upcoming: requestType = .upcoming
        case .popular: requestType = .popular
        }
        await loadMore(for: requestType)
    }
    
    private func loadMore(for type: MovieRequestType) async {
        print("🔵 loadMore 실행: \(type), page: \(currentPage[type, default: 1])")
        guard await loadingState.checkAndSetLoading(for: type) else { return }

        
        let result = await repository.fetchMovies(by: type, page: currentPage[type, default: 1])
        await MainActor.run {
            switch result {
            case .success(let info):
//                print(info.currentPage, info.totalPages, info.totalResults)
                let insertedIndexPaths = updatePublishedMovies(info.movies, for: type)
                currentPage[type] = info.currentPage + 1
                totalPages[type] = info.totalPages
                insertedIndexPathsPublisher.send((type, insertedIndexPaths))
            case .failure:
                break
                
            }
        }
            await loadingState.setFinished(for: type)
        }
    
    
    private func updatePublishedMovies(_ newMovies: [Movie], for type: MovieRequestType) -> [IndexPath] {
        let startIndex: Int
        let section: Int
        var insertedPaths: [IndexPath] = []

        switch type {
        case .upcoming:
            startIndex = upcoming.count
            upcoming += newMovies
            section = 0
        case .nowPlaying:
            startIndex = nowPlaying.count
            nowPlaying += newMovies
            section = 1

        case .popular:
            startIndex = popular.count
            popular += newMovies
            section = 2
        }

        let endIndex = startIndex + newMovies.count
        insertedPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: section) }

        return insertedPaths
    }
    func currentPage(for section: SectionType) -> Int {
        switch section {
        case .nowPlaying: return currentPage[.nowPlaying] ?? 1
        case .upcoming: return currentPage[.upcoming] ?? 1
        case .popular: return currentPage[.popular] ?? 1
        }
    }

}

actor MovieLoadingState {
    private var isLoading: [MovieRequestType: Bool] = [:]

    func checkAndSetLoading(for type: MovieRequestType) -> Bool {
        if isLoading[type] == true { return false }
        isLoading[type] = true
        return true
    }

    func setFinished(for type: MovieRequestType) {
        isLoading[type] = false
    }
}
