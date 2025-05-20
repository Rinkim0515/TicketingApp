//
//  MovieDetailDTO.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genres: [GenreDTO]
    let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
