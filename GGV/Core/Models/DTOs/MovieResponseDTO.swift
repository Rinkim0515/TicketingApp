//
//  UpcomingModel.swift
//  TeamOne1
//
//  Created by t2023-m0102 on 7/24/24.
//

import Foundation

//MARK: - 목록 용도
struct MovieResponseDTO: Codable {
    let page: Int
    let totalPages: Int?
    let totalResults: Int?
    let movies: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}




