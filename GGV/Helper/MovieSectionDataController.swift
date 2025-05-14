//
//  MovieSectionDataController.swift
//  GGV
//
//  Created by KimRin on 5/14/25.
//

import Foundation
final class MovieSectionDataController {
    private let requestType: MovieRequestType
    private var cachedMovies: [Movie] = []
    private(set) var currentPage = 1
    private let pageSize = 20

    init(requestType: MovieRequestType) {
        self.requestType = requestType
    }

    func syncFromRepo() {
        switch requestType {
        case .nowPlaying:
            let repoCache = MovieRepository.shared.nowPlayingCache
            if repoCache.count > cachedMovies.count {
                cachedMovies = repoCache
            }
        case .upcoming, .popular:
            // Optional: handle cache for other types if implemented
            break
        }
    }

    func currentItems() -> [Movie] {
        Array(cachedMovies.prefix(currentPage * pageSize))
    }

    func nextPageItems() -> [Movie] {
        currentPage += 1
        return currentItems()
    }

    func reset() {
        currentPage = 1
    }
}

enum SharedSectionControllers {
    static let nowPlaying = MovieSectionDataController(requestType: .nowPlaying)
}
