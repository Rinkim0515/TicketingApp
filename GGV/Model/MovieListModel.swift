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
  let id: Int
  let title: String
  let posterPath: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
  }
}


