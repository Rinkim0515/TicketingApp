//
//  SearchMovie.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation

struct SearchMovie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct MovieSearchResponse: Codable {
    let results: [SearchMovie]
}
