//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
// 추후에 에러만을 처리하는 로직을 따로 만들어야함

import Foundation

class MovieRepository {
    static let shared = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    
    private init() {}
    
    func requestData(type: MovieRequestType, isNowPlaying: Bool = false) async -> Result<[Movie],Error> {
        do {
            let dtos = try await movieNetwork.fetchMovies(from: type.endpoint)
            let movies = dtos.map { Movie(from: $0, isNowPlaying: isNowPlaying) }
            return .success(movies)
        } catch {
            return .failure(error)
        }
        
    }
    
    
    // MARK: - 영화 상세
    func requestData(for movieID: Int) async -> Result<Movie, Error> {
        do {
            guard let dto = try await movieNetwork.fetchMovieDetailInfo(movieId: movieID) else {
                return .failure(URLError(.badServerResponse))
            }
            return .success(Movie(from: dto))
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - 영화 검색
    func requestData(from query: String) async -> Result<[Movie], Error> {
        do {
            let searchResults = try await movieNetwork.searchMovies(query: query)
            let movies = searchResults.map { Movie(from: $0) }
            return .success(movies)
        } catch {
            return .failure(error)
        }
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
