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

struct MovieListInfo {
    let movies: [Movie]
    let totalResults: Int?        // 전체 결과 수
    let totalPages: Int? // TMDB에서 페이지 수를안줄때
    let currentPage: Int
    
    var isEmpty: Bool { // 검색결과가 없을때
        return movies.isEmpty
    }
    
    var isLastPage: Bool {
        guard let totalPages else { return true } // 없으면 끝으로 간주
        return currentPage >= totalPages
        
    }
}




