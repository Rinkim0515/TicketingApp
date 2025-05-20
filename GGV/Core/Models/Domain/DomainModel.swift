//
//  DomainModel.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation

struct Movie: Hashable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let overview: String?
    let voteAverage: Double?
    let genreNames: [String]
    
}

