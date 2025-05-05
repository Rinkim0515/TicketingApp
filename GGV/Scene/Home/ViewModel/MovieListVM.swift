//
//  MovieListVM.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import Foundation
import Combine

final class MovieListVM: ObservableObject {
    @Published var isLoading: Bool = false // 데이터 플래그
    @Published var nowPlaying: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var popular: [Movie] = []
    
    func fetchAll() async {
        isLoading = true
        
        async let nowRaw = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)now_playing")
        async let upcRaw = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)upcoming")
        async let popRaw = MovieNetwork.shared.fetchMovies(from: "\(Constants.BASE_URL)popular")

        //DTO모델에서  Domain모델로 변경
        let now = await nowRaw.map { Movie(from: $0, isNowPlaying: true) }
        let upc = await upcRaw.map { Movie(from: $0, isNowPlaying: true) }
        let pop = await popRaw.map { Movie(from: $0, isNowPlaying: true) }

        self.nowPlaying = now
        self.upcoming = upc
        self.popular = pop
        
        isLoading = false
    }
}
