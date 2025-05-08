//
//  MovieDetailVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 일단 상영중인 영화의 리스트는 보여주고 검색을 하면 모든 영화에서 검색을 진행하며 이 영화가 상영중이 아니라면 예매 버튼을 막아두기

//

import Foundation
import Combine

final class MovieDetailVM {
    @Published var movie: Movie
    @Published var isNowPlaying: Bool
    @Published var isLoading: Bool = false
    private let repository = MovieRepository.shared

    init(movie: Movie) {
        self.movie = movie
        self.isNowPlaying = movie.isNowPlaying
    }
    
    func fetchDetail() async {
        isLoading = true
//        let result = await MovieNetwork().fetchMovieDetailInfo(movieId: movie.id)
        let result = await repository.requestData(for: movie.id)
        await MainActor.run {
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                print("❗️영화 상세 로딩 실패: \(error.localizedDescription)")
            }
        }
        self.isLoading = false
    }
}
