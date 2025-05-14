//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    private let nowPlayingController = SharedSectionControllers.nowPlaying
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []


    static var instanceCount = 0
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
    
    /// Register a closure to be called when nowPlaying cache is ready.

    
    func fetchAllFromCache() async{
        print("🟢 fetchAllFromCache 진입")
            await loadMoreIfNeeded(for: .nowPlaying)
        await loadMoreIfNeeded(for: .popular)
        await loadMoreIfNeeded(for: .upcoming)
    }
    
    func loadMoreIfNeeded(for section: SectionType) async {
        let requestType: MovieRequestType
        switch section {
        case .upcoming : requestType = .upcoming
        case .nowPlaying: requestType = .nowPlaying
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
                print(info.movies.count)
                updatePublishedMovies(info.movies, for: type)
//                let insertedIndexPaths = updatePublishedMovies(info.movies, for: type)
                currentPage[type] = info.currentPage + 1
                totalPages[type] = info.totalPages
                
//                insertedIndexPathsPublisher.send((type, insertedIndexPaths))
            case .failure:
                break
                
            }
        }
            await loadingState.setFinished(for: type)
        }
    
    
    private func updatePublishedMovies(_ newMovies: [Movie], for type: MovieRequestType) {
//        let startIndex: Int
//        let section: Int
//        var insertedPaths: [IndexPath] = []

        switch type {
        case .upcoming:
            
            upcoming += newMovies
            
        case .nowPlaying:
            
            nowPlaying += newMovies
            

        case .popular:
            
            popular += newMovies
            
        }

//        let endIndex = startIndex + newMovies.count
//        insertedPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: section) }
//
//        return insertedPaths
    }
    func currentPage(for section: SectionType) -> Int {
        switch section {
        case .nowPlaying: return currentPage[.nowPlaying] ?? 1
        case .upcoming: return currentPage[.upcoming] ?? 1
        case .popular: return currentPage[.popular] ?? 1
        }
    }
    
    func items(for section: SectionType) -> [Movie] {
        switch section {
        case .upcoming: return upcoming
        case .nowPlaying: return nowPlaying
        case .popular: return popular
        }
    }
    
    func hasMorePages(for section: SectionType) -> Bool {
        let requestType = requestType(from: section)
        guard let total = totalPages[requestType] else { return true }
        return currentPage[requestType, default: 1] <= total
    }
    
    private func requestType(from section: SectionType) -> MovieRequestType {
        switch section {
        case .upcoming: return .upcoming
        case .nowPlaying: return .nowPlaying
        case .popular: return .popular
        }
    }

}

// MARK: - MovieSectionDataController Integration
extension MovieListVM {
    /// Sync nowPlayingCardModels from the data controller cache
    ///
    func syncNowPlayingFromCache() {
        nowPlayingController.syncFromRepo()
        let domainModels = nowPlayingController.currentItems()
        let uiModels = domainModels.map {
            MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: true)
        }
        nowPlayingCardModels = uiModels
    }

    /// Load next page for nowPlaying and update nowPlayingCardModels
    func loadNextNowPlayingPage() {
        let domainModels = nowPlayingController.nextPageItems()
        let uiModels = domainModels.map {
            MovieUIModelMapper.mapToCardModel(from: $0, isNowPlaying: true)
        }
        nowPlayingCardModels = uiModels
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
