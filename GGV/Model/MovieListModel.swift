//
//  UpcomingModel.swift
//  TeamOne1
//
//  Created by t2023-m0102 on 7/24/24.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieListModel]
}

struct MovieListModel: Codable {
    let id: Int // 영화 고유 ID
    let title: String // 영화 한글 이름
    let posterPath: String? // 영화 세로 포스터 이미지
    let backdropPath: String? // 영화 가로 포스터 이미지
    let popularity: String? // 선호도
    let genres: [Int] = [] // 영화장르
    
    enum CodingKeys: String, CodingKey {
        case id, title, popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}


/*
 MOVIE
 Action          28
 Adventure       12
 Animation       16
 Comedy          35
 Crime           80
 Documentary     99
 Drama           18
 Family          10751
 Fantasy         14
 History         36
 Horror          27
 Music           10402
 Mystery         9648
 Romance         10749
 Science Fiction 878
 TV Movie        10770
 Thriller        53
 War             10752
 Western         37
 */
