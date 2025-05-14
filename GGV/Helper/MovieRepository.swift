//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
// 모든 영화 데이터를 호출하고 보관하는 싱글톤 페이징 처리를 해야하긴한다.

/*
 비동기 작업 간 충돌 처리
 •    예: 초기 로딩 중간에 스크롤해서 추가 로딩이 들어가면 데이터가 꼬일 가능성
 
 → 해결책: 동시성 제어 (예: TaskQueue or CombineLatest 조절 등)
 4. 네트워크 실패 후 복구 전략
 •    현재는 실패하면 print하고 배열 초기화인데,
 •    실제 앱에서는 유저에게 retry 기회나 오프라인 fallback 캐시 도입 고려 가능
 3. 검색 쪽 페이징 구조는 아직 단순
 •    현재 requestData(from:query,page:)는 totalPages 반환 안 함
 •    UI에서 “다음 페이지 있음”을 알 수 없음
 
 → 개선안: Result를 [Movie] → ([Movie], totalPages: Int) 로 바꾸는 것도 고려
 
 */

import Foundation

class MovieRepository {
    static let shared = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    //MARK: - MovieProperty
    private(set) var nowPlayingCache: [Movie] = [] // 캐싱 처리할 영화 리스트
    var nowPlayingCurrentPage: Int = 1
    var nowPlayingTotalPages: Int?
    var nowPlayingMoviesAmount: Int = 0
    private var nowPlayingCacheCompletion: (([Movie], Int, Int?) -> Void)?
    
    func observeNowPlayingCache(_ handler: @escaping ([Movie], Int, Int?) -> Void) {
        nowPlayingCacheCompletion = handler
    }
    
    
    
    private init() {}
    
    // 상영중 영화를 검색할시에 불러올메서드
    func preloadNowPlayingAll() async -> Result<Void, AppError> {
        var page = nowPlayingCurrentPage

        var accumulatedMovies: [Movie] = nowPlayingCache
        var seenIDs = Set(accumulatedMovies.map { $0.id })
        var finalPage = page
        var finalTotalPages: Int?

        while true {

        
            let result = await fetchRawMovies(by: .nowPlaying, page: page)
            switch result {
            case .success(let info):
                let filtered = info.movies.filter { movie in
                    guard !seenIDs.contains(movie.id) else { return false }
                    seenIDs.insert(movie.id)
                    return true
                }
                accumulatedMovies += filtered
                finalPage = info.currentPage
                finalTotalPages = info.totalPages
                if page >= (info.totalPages ?? .max) {
                    break
                }
                page += 1
            case .failure(let error):
                return .failure(error)
            }
        }

        nowPlayingCache = accumulatedMovies
        nowPlayingCurrentPage = finalPage
        nowPlayingTotalPages = finalTotalPages
        
        nowPlayingCacheCompletion?(nowPlayingCache, nowPlayingCurrentPage, nowPlayingTotalPages)
        nowPlayingCacheCompletion = nil // Ensure one-time use
        
        return .success(())
    }
    
    
    // MARK: - 영화 상세 정보 호출
    func requestData(for movieID: Int) async -> Result<Movie, Error> {
        do {
            guard let dto = try await movieNetwork.fetchMovieDetailInfo(movieId: movieID) else {
                return .failure(URLError(.badServerResponse))
            }
            return .success(Movie(from: dto))
        } catch {
            return .failure(error)
        }
    }
    
    private func fetchRawMovies(by type: MovieRequestType, page: Int) async -> Result<MovieListInfo, AppError> {
        do {
            let response = try await movieNetwork.fetchMovieList(page: page, type: type)
            let movies = response.movies.map { Movie(from: $0, isNowPlaying: (type == .nowPlaying)) }

            return .success(MovieListInfo(
                movies: movies,
                totalResults: response.totalResults,
                totalPages: response.totalPages,
                currentPage: page
            ))
        } catch {
            return .failure(.network(.decodingFailed))
        }
    }
    
    
    func fetchMovies(by type: MovieRequestType, page: Int) async -> Result<MovieListInfo, AppError> {
        print("🟣 fetchMovies 요청: \(type), page: \(page)")
            
        do {
            let response = try await movieNetwork.fetchMovieList(page: page, type: type)
            var movies: [Movie]
            
     
                movies = response.movies.map { Movie(from: $0) }
            
            
            
            
            return .success(MovieListInfo(
                movies: movies,
                totalResults: response.totalResults,
                totalPages: response.totalPages,
                currentPage: page
            ))
        } catch {
            return .failure(.network(.decodingFailed))
        }
    }
    
    func fetchSearchMovies(query: String, page: Int) async -> Result<MovieListInfo, AppError> {
        do {
            let results = try await movieNetwork.searchMovies(query: query, page: page)
            let movies = results.map { Movie(from: $0) }
            return .success(MovieListInfo(
                movies: movies,
                totalResults: movies.count,
                totalPages: nil,
                currentPage: page
            ))
        } catch {
            return .failure(.network(.decodingFailed))
        }
        
        
    }
}





