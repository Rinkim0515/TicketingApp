//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
// 추후에 에러만을 처리하는 로직을 따로 만들어야함 

import Foundation

class MovieRepository {
    static let movieRepository = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    
    private init() {}
    
    func requestData(type: MovieRequestType) async throws -> [Movie] {
        let dtos = try await movieNetwork.fetchMovies(from: type.endpoint)
        return dtos.map { Movie(from: $0) }
    }
    
    
    // MARK: - 영화 상세
    func requestData(for movieID: Int) async -> Movie? {
        
        guard let detailDTO =  try? await movieNetwork.fetchMovieDetailInfo(movieId: movieID) else {
            return nil
        }
        
        return Movie(from: detailDTO)
    }
    
    // MARK: - 영화 검색
    func requestData(from query: String) async throws -> [Movie] {
        let searchResults = try await movieNetwork.searchMovies(query: query)
        return searchResults.map { Movie(from: $0) }
    }
    
    
}

enum MovieRequestType {
    case nowPlaying
    case upcoming
    case popular
}

extension MovieRequestType {
    var endpoint: String {
        switch self {
        case .nowPlaying: return "\(Constants.BASE_URL)now_playing"
        case .upcoming: return "\(Constants.BASE_URL)upcoming"
        case .popular: return "\(Constants.BASE_URL)popular"
        }
    }
}
