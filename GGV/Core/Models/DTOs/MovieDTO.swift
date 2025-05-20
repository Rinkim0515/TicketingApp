//
//  MovieDTO.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

struct MovieDTO: Codable {
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
