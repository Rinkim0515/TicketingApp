//
//  MovieSearchVM.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
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
