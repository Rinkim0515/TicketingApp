//
//  UI.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

struct MovieUIModelMapper {
    
    static func mapToBannerModel(from movie: Movie) -> MovieBannerCellModel {
        return MovieBannerCellModel(
            id: movie.id,
            title: movie.title,
            backdropPath: movie.backdropPath,
            posterPath: movie.posterPath
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
            backdropPath: movie.backdropPath
            
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
