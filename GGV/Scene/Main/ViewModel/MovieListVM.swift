//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation

final class MovieListVM {
    var nowPlaying: [MovieListModel] = [] {
        didSet { onUpdateNowPlaying?() }
    }

    var upcoming: [MovieListModel] = [] {
        didSet { onUpdateUpcoming?() }
    }

    var popular: [MovieListModel] = [] {
        didSet { onUpdatePopular?() }
    }

    var onUpdateNowPlaying: (() -> Void)?
    var onUpdateUpcoming: (() -> Void)?
    var onUpdatePopular: (() -> Void)?

    func fetchAll() async {
        async let now = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing")
        async let upc = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming")
        async let pop = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular")

        self.nowPlaying = await now
        self.upcoming = await upc
        self.popular = await pop
    }
}
