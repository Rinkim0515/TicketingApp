//
//  MovieDetailVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//250519

import Foundation
import Combine

final class MovieDetailVM {
    @Published var movie: Movie? = nil
    @Published var isNowPlaying: Bool = false
    @Published var isLoading: Bool = false
    private let movieId: Int
    private let repository = MovieRepository.shared
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchDetail() async{
        isLoading = true
        let result = await repository.requestData(for: movieId)
        await MainActor.run {
            switch result {
            case .success(let fetchedMovie):
                self.movie = fetchedMovie
            case .failure(let error):
                print("❗️영화 상세 로딩 실패: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
}
