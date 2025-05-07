//
//  DomainModel.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation

struct Movie: Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let overview: String?
    let voteAverage: Double?
    var isNowPlaying: Bool = false
    let genreNames: [String]
    
    //MARK: - ListModel에서 변환 초기생성자
    init(from dto: MovieListModel, isNowPlaying: Bool = false) {
        self.id = dto.id
        self.title = dto.title
        self.posterPath = dto.posterPath
        self.backdropPath = dto.backdropPath
        self.releaseDate = nil
        self.overview = nil
        self.voteAverage = nil
        self.isNowPlaying = isNowPlaying
        self.genreNames = []
    }
    
    //MARK: - DetailVC에서 변환 초기생성자
    init(from dto: MovieDetailModel) {
        self.id = dto.id
        self.title = dto.title
        self.posterPath = dto.posterPath
        self.backdropPath = nil
        self.releaseDate = dto.releaseDate
        self.overview = dto.overview
        self.voteAverage = dto.voteAverage
        self.isNowPlaying = false
        self.genreNames = dto.genres.map { $0.name }
    }
}

