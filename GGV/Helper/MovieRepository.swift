//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
//

import Foundation

class MovieRepository {
    static let movieRepository = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    
    private init() {}
    
   
    
    
    func fetchDetailMovieInfo(from movieID: Int) -> Movie {
        
    }
    
    func searchMovies(from query: String) -> [Movie] {
        
    }
    
    
}
