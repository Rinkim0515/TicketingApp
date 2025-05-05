//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    @Published var nowPlaying: [MovieListModel] = []
    @Published var upcoming: [MovieListModel] = []
    @Published var popular: [MovieListModel] = []
    
    func fetchAll() async {
        async let now = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing")
        async let upc = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming")
        async let pop = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular")

        self.nowPlaying = await now
        self.upcoming = await upc
        self.popular = await pop
    }
}
