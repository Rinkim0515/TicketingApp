//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
// 


import Foundation

class MovieRepository {
    static let shared = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    
    
    
    private init() {}
    

    
    
    // MARK: - 영화 상세 정보 호출
    
    func requestData(for movieID: Int) async -> Result<Movie, Error> {
        do {
            guard let dto = try await movieNetwork.fetchMovieDetailInfo(movieId: movieID) else {
                return .failure(URLError(.badServerResponse))
            }
            //MovieDetailDTO -> Movie
            return .success(MovieModelMapper.map(from: dto))
                
        } catch {
            return .failure(error)
        }
    }
    
    func fetchMovies(by type: MovieCategory, page: Int) async -> Result<MovieListInfo, AppError> {
            
        do {
            let response = try await movieNetwork.fetchMovieList(page: page, type: type)
            var movies: [Movie]
            
            movies = response.movies.map { MovieModelMapper.map(from: $0) }
            return .success(MovieListInfo(
                movies: movies,
                totalResults: response.totalResults,
                totalPages: response.totalPages,
                currentPage: page
            ))
        } catch {
            return .failure(.network(.decodingFailed))
        }
    }
    
    func fetchSearchMovies(query: String, page: Int) async -> Result<MovieListInfo, AppError> {
        do {
            let results = try await movieNetwork.searchMovies(query: query, page: page)
            
            
            return .success(
                MovieModelMapper.map(from: results))
        } catch {
            return .failure(.network(.decodingFailed))
        }
        
        
    }
    
}





