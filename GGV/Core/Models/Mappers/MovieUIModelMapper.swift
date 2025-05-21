//
//  UI.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

struct MovieUIModelMapper {
    
    static func mapToBannerModel(from movie: Movie) -> MovieBannerCellModel {
        return mapToBannerModel(from: movie, category: .upcoming)
    }
    static func mapToCardModel(from movie: Movie, isNowPlaying: Bool = false) -> MovieCardCellModel {
        return mapToCardModel(from: movie, category: isNowPlaying ? .nowPlaying : .popular, isNowPlaying: isNowPlaying)
    }
    
    static func mapToCardModel(from movie: Movie, category: MovieCategory, isNowPlaying: Bool = false) -> MovieCardCellModel {
        return MovieCardCellModel(
            id: MovieCardCellModel.Identifier(categoryId: category.rawValue, movieId: movie.id),
            movieId: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            isNowPlaying: isNowPlaying
        )
    }

    // 카테고리 정보를 포함한 배너 모델 매핑 메서드 추가
    static func mapToBannerModel(from movie: Movie, category: MovieCategory) -> MovieBannerCellModel {
        return MovieBannerCellModel(
            id: MovieBannerCellModel.Identifier(categoryId: category.rawValue, movieId: movie.id),
            movieId: movie.id,
            title: movie.title,
            backdropPath: movie.backdropPath,
            posterPath: movie.posterPath
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
