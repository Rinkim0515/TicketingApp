//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
// 검색을 요청하는 방식을 바꿔야 할듯하다. 입력이 없는채로 2초 이상 두면 검색이 돌수 있도록 하는방식
// 상영중인 영화는 어떻게 처리를 할것인가 에대한 고민 그니까 검색을 하는것을 감지를해서 검색을 하는도중에 검색창이
// 

import Foundation

@MainActor
final class MovieSearchVM {
    @Published private(set) var searchResults: [Movie] = []
    private let repository = MovieRepository.shared
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var isLoadingMore = false
    
    //Search
    func search(query: String) async {
        currentQuery = query
        currentPage = 1
        guard !query.isEmpty else { self.searchResults = []; return }
        
        let resultRaw = await repository.requestData(from: query,page: currentPage)
        switch resultRaw {
        case .success(let movies):
            self.searchResults = movies
        case .failure(let error):
            print("검색 실패: \(error.localizedDescription)")
        }
    }
    
    func loadMoreSearchResults() async {
        guard !currentQuery.isEmpty, !isLoadingMore else { return }
        isLoadingMore = true
        currentPage += 1
        
        let resultRaw = await repository.requestData(from: currentQuery, page: currentPage)
        
        switch resultRaw {
        case .success(let movies):
            self.searchResults += movies
        case .failure(let error):
            print("추가 검색 실패: \(error.localizedDescription)")
        }
        isLoadingMore = false
    }

}

extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = format
        return df.date(from: self)
    }
}
