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
        let movies = response.movies.map { dto in
            MovieModelMapper.map(from: dto)
        }
        
        return MovieListInfo(
            movies: movies,
            totalResults: response.totalResults,
            totalPages: response.totalPages,
            currentPage: response.page
        )
    }
    
    /// MovieDTO -> Domain.Movie 변환
    static func map(from dto: MovieDTO, genreNames: [String] = []) -> Movie {
        return Movie(
            id: dto.id,
            title: dto.title,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            releaseDate: nil,
            overview: nil,
            voteAverage: nil,
            
            genreNames: genreNames
        )
    }
    static func map(from dto: MovieDetailDTO/*, genreNames: [String] = []*/) -> Movie {
        return Movie(
            id: dto.id,
            title: dto.title,
            posterPath: dto.posterPath,
            backdropPath: nil,
            releaseDate: nil,
            overview: nil,
            voteAverage: nil,
            
            genreNames: []
        )
    }
}

struct MovieUIModelMapper {
    
    static func mapToBannerModel(from movie: Movie) -> MovieBannerCellModel {
        return MovieBannerCellModel(
            id: movie.id,
            title: movie.title,
            backdropPath: movie.backdropPath
        )
    }
    static func mapToCardModel(from movie: Movie, isNowPlaying: Bool = false) -> MovieCardCellModel {
        return MovieCardCellModel(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            isNowPlaying: isNowPlaying
        )
    }
    
    
    static func mapToSearchModel(from movie: Movie) -> MovieSearchCellModel {
        return MovieSearchCellModel(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            overview: movie.overview
        )
    }
    
    static func mapToDetailModel(from movie: Movie, isNowPlaying: Bool = false) -> MovieDetailUIModel {
        return MovieDetailUIModel(
            id: movie.id,
            title: movie.title,
            releaseDate: movie.releaseDate ?? "-",
            overview: movie.overview ?? "",
            posterPath: movie.posterPath,
            voteAverage: movie.voteAverage ?? 0.0,
            genres: movie.genreNames,
            isNowPlaying: isNowPlaying
        )
    }
}
    
