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
    @Published private(set) var nowPlayingIDs: Set<Int> = []
    @Published private(set) var nowPlayingMovies: [MovieListModel] = []
    private let movieNetwork = MovieNetwork.shared
    
    func search(query: String) async {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        if nowPlayingIDs.isEmpty {
            await fetchNowPlayingIDs()
        }
        
        do {
            let resultRaw = try await movieNetwork.searchMovies(query: query)
            let nowPlayingTitles = Set(nowPlayingMovies.map { $0.title })
            
            let result = resultRaw.map { dto in
                let isNowPlaying = isNowPlayingLike(dto: dto, nowPlayingTitles: nowPlayingTitles)
                print("🔍 \(dto.title): \(dto.id) → \(isNowPlaying ? "예매 가능" : "예매 불가")")
                return Movie(from: dto, isNowPlaying: isNowPlaying)
            }

            self.searchResults = result
        } catch {
            print("영화 검색 실패: \(error.localizedDescription)")
        }
        
        func isNowPlaying(_ days: Int) -> Bool {
            return (0...90).contains(days)
        }
        
        
        
        
        
    }
    
    private func isNowPlayingLike(dto: MovieListModel, nowPlayingTitles: Set<String>) -> Bool {
        print("🎬 검색된 제목: \(dto.title)")
        print("🎬 상영중 제목 목록: \(nowPlayingTitles)")
        print("🎬 제목 매칭 결과: \(nowPlayingTitles.contains(dto.title))")
        print("📅 출시일: \(dto.releaseDate)")
        
        if nowPlayingIDs.contains(dto.id) {
            return true
        }

        if nowPlayingTitles.contains(dto.title) {
            if let releaseDate = dto.releaseDate.toDate(format: "yyyy-MM-dd") {
                let days = Calendar.current.dateComponents([.day], from: releaseDate, to: Date()).day ?? 999
                return (0...30).contains(days)
            }
        }
        return false
    }
    
    func fetchNowPlayingIDs() async {
        var page = 1
        var allMovies: [MovieListModel] = []
        var hasMore = true
        while hasMore {
            do {
                let movies = try await movieNetwork.fetchNowPlayingMovies(page: page)
                if movies.isEmpty {
                    hasMore = false
                } else {
                    allMovies.append(contentsOf: movies)
                    page += 1
                }
            } catch {
                print("로딩 실패: \(error.localizedDescription)")
                hasMore = false
                
            }
            

        }
        
        self.nowPlayingMovies = allMovies
        self.nowPlayingIDs = Set(allMovies.map { $0.id })
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
