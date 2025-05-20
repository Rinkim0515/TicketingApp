//
//  MovieMapper.swift
//  GGV
//
//  Created by KimRin on 5/14/25.
//

import Foundation

struct MovieModelMapper {
    /// MovieResponseDTO -> MovieListInfo 변환
    static func map(from response: MovieResponseDTO) -> MovieListInfo {
        let movies = response.movies.enumerated().map { index, dto in
            return MovieModelMapper.map(from: dto)
        }
        
        return MovieListInfo(
            movies: movies,
            totalResults: response.totalResults,
            totalPages: response.totalPages,
            currentPage: response.page
        )
    }
    
    /// MovieDTO -> Domain.Movie 변환
    static func map(from movieDto: MovieDTO) -> Movie {
        return Movie(
            id: movieDto.id,
            title: movieDto.title,
            posterPath: movieDto.posterPath,
            backdropPath: movieDto.backdropPath,
            releaseDate: nil,
            overview: nil,
            voteAverage: nil,
            genreNames: []
        )
    }
    
    static func map(from movieDetailDto: MovieDetailDTO) -> Movie {
        return Movie(
            id: movieDetailDto.id,
            title: movieDetailDto.title,
            posterPath: movieDetailDto.posterPath,
            backdropPath: nil,
            releaseDate: movieDetailDto.releaseDate,
            overview: movieDetailDto.overview,
            voteAverage: movieDetailDto.voteAverage,
            genreNames: movieDetailDto.genres.map{ $0.name}
        )
    }
}


    
