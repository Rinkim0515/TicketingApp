//
//  UIModel.swift
//  GGV
//
//  Created by KimRin on 5/14/25.
//

import Foundation


enum MovieCategory: Int, CaseIterable {
    case upcoming = 0
    case nowPlaying
    case popular

    var title: String {
        switch self {
        case .nowPlaying: return "현재 상영 영화"
        case .upcoming: return "상영 예정 영화"
        case .popular: return "인기 영화"
        }
    }

    var endpoint: String {
        switch self {
        case .nowPlaying: return "\(Constants.BASE_URL)now_playing"
        case .upcoming: return "\(Constants.BASE_URL)upcoming"
        case .popular: return "\(Constants.BASE_URL)popular"
        }
    }
}


// MARK: - UI Models

struct MovieBannerCellModel: Hashable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    
}

struct MovieCardCellModel: Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let isNowPlaying: Bool
}

struct MovieSearchCellModel: Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    
}

struct MovieDetailUIModel: Hashable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let genres: [String]
    let isNowPlaying: Bool
}



enum MovieListItem: Hashable {
    case banner(MovieBannerCellModel)
    case card(MovieCardCellModel)
}
