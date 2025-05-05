//
//  MovieDetailVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 
//

import Foundation

final class MovieDetailVM {
    @Published private(set) var movieDetail: MovieDetailModel?
    @Published private(set) var isLoading: Bool = false
    
    func fetchDetail(for movieId: Int) async {
        isLoading = true
        let result = await MovieNetwork().getData(movieId: movieId)
        await MainActor.run {
            self.movieDetail = result
            self.isLoading = false
        }
    }
}
