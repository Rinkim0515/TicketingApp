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
    private let repository = MovieRepository.shared
    func fetchAll() async {
        isLoading = true
        
        async let nowResult = repository.requestData(type: .nowPlaying, isNowPlaying: true)
        async let upcResult = repository.requestData(type: .upcoming)
        async let popResult = repository.requestData(type: .popular)

        let (nowPlayingResult, upcomingResult, popularResult) =  await (nowResult, upcResult, popResult)

        switch nowPlayingResult {
        case .success(let movies):
            self.nowPlaying = movies
        case .failure(let error):
            print("❗️상영 중 영화 로딩 실패: \(error.localizedDescription)")
            self.nowPlaying = []
        }

        switch upcomingResult {
        case .success(let movies):
            self.upcoming = movies
        case .failure(let error):
            print("❗️상영 예정 영화 로딩 실패: \(error.localizedDescription)")
            self.upcoming = []
        }

        switch popularResult {
        case .success(let movies):
            self.popular = movies
        case .failure(let error):
            print("❗️인기 영화 로딩 실패: \(error.localizedDescription)")
            self.popular = []
        }
        
        
        isLoading = false
    }
}
