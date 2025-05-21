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
    struct Identifier: Hashable {
        let categoryId: Int
        let movieId: Int
    }
    let id: Identifier      // 복합 식별자
    let movieId: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    
}

struct MovieCardCellModel: Hashable {
    struct Identifier: Hashable {
        let categoryId: Int
        let movieId: Int
    }
    let id: Identifier      // 복합 식별자
    let movieId: Int
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
    
    // Hashable 명시적 구현
    func hash(into hasher: inout Hasher) {
        switch self {
        case .banner(let model):
            // 케이스와 모델의 복합 식별자를 해시에 포함
            hasher.combine(0) // banner 케이스를 나타내는 상수
            hasher.combine(model.id)
        case .card(let model):
            // 케이스와 모델의 복합 식별자를 해시에 포함
            hasher.combine(1) // card 케이스를 나타내는 상수
            hasher.combine(model.id)
        }
    }
    static func == (lhs: MovieListItem, rhs: MovieListItem) -> Bool {
        switch (lhs, rhs) {
        case (.banner(let lhsModel), .banner(let rhsModel)):
            return lhsModel.id == rhsModel.id
        case (.card(let lhsModel), .card(let rhsModel)):
            return lhsModel.id == rhsModel.id
        default:
            return false
        }
    }
        
        
}

struct SearchResultUIModel {
    let results: [MovieSearchCellModel]
    let totalCount: Int
    let isEmptyResult: Bool
    let errorMessage: String?
}
