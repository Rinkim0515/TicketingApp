//
//  MovieDetailVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 일단 상영중인 영화의 리스트는 보여주고 검색을 하면 모든 영화에서 검색을 진행하며 이 영화가 상영중이 아니라면 예매 버튼을 막아두기

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
