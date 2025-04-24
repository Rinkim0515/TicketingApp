import Foundation

struct MovieDetailModel: Codable {
  let title: String
  let releaseDate: String
  let posterPath: String
  let overview: String
  let voteAverage: Double
  
  enum CodingKeys: String, CodingKey {
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
    case overview
    case voteAverage = "vote_average"
  }
}


