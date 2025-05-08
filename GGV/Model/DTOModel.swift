//
//  UpcomingModel.swift
//  TeamOne1
//
//  Created by t2023-m0102 on 7/24/24.
//

import Foundation

//MARK: - 목록 용도
struct MovieResponse: Codable {
    let page: Int
    let totalPages: Int
    let results: [MovieListModel]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}
struct MovieListModel: Codable {
    let id: Int // 영화 고유 ID
    let title: String // 영화 한글 이름
    let posterPath: String? // 영화 세로 포스터 이미지
    let backdropPath: String? // 영화 가로 포스터 이미지
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}


//MARK: - 상세정보 용도
struct MovieDetailModel: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    let overview: String
    let voteAverage: Double
    let genres: [GenreDTO]
    enum CodingKeys: String, CodingKey {
        case title, overview, id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genres
    }
}
struct GenreDTO: Codable {
    let id: Int
    let name: String
}

