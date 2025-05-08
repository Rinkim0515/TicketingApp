//
//  MovieRepository.swift
//  GGV
//
//  Created by KimRin on 5/6/25.
// 모든 영화 데이터를 호출하고 보관하는 싱글톤 페이징 처리를 해야하긴한다.

import Foundation

class MovieRepository {
    static let shared = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    //MARK: - MovieProperty
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upcommingMovies: [Movie] = []
    var searchMovies: [Movie] = []
    //MARK: - CurrentPages
    var nowPlayingCurrentPage: Int = 1
    var popularCurrentPage: Int = 1
    var upcommingCurrentPage: Int = 1
    var searchMoviesCurrentPage: Int = 1
    //MARK: - TotalPages
    var nowPlayingTotalPages: Int?
    var popularTotalPages: Int?
    var upcommingTotalPages: Int?
    var searchMoviesTotalPages: Int?
    
    
    private init() {
        
    }
    

    
    //MARK: - 상영중 영화리스트 호출
    func fetchNowplayingMovies() async {
        let currentPage = nowPlayingCurrentPage
        let isNowPlaying = true
        let requestType: MovieRequestType = .nowPlaying

        let result = await requestData(type: requestType, page: currentPage, isNowPlaying: isNowPlaying)

        switch result {
        case .success(let data):
            let initMovies = data.0
            let totalPages = data.totalPages
            self.nowPlayingMovies = initMovies
            self.nowPlayingTotalPages = totalPages // 여기가 누락이 된다면 ?
        case .failure(let error):
            print("❗️상영 중 영화 로딩 실패: \(error.localizedDescription)")
            self.nowPlayingMovies = []
        }
    }
    //MARK: - 인기영화리스트 호출
    func fetchPopularMovies() async {
        let currentPage = popularCurrentPage
        let requestType: MovieRequestType = .popular

        let result = await requestData(type: requestType, page: currentPage)

        switch result {
        case .success(let data):
            let initMovies = data.0
            let totalPages = data.totalPages

            self.popularMovies = initMovies
            self.popularTotalPages = totalPages

        case .failure(let error):
            print("❗️상영 예정 영화 로딩 실패: \(error.localizedDescription)")
            self.popularMovies = []
        }
    }
    //MARK: - 상영예정작리스트 호출
    func fetchUpcommingMovies() async {
        let currentPage = upcommingCurrentPage
        let requestType: MovieRequestType = .upcoming
        let result = await requestData(type: requestType, page: currentPage)
        switch result {
        case .success(let data):
            let initMovies = data.0
            let totalPages = data.totalPages
            self.upcommingMovies = initMovies
            self.upcommingTotalPages = totalPages
        case .failure(let error):
            print("❗️인기 영화 로딩 실패: \(error.localizedDescription)")
            self.upcommingMovies = []
        }
    }
    
    
    //MARK: - 키워드방식 정보 호출
    func requestData(type: MovieRequestType, page: Int = 1, isNowPlaying: Bool = false) async -> Result<([Movie],totalPages: Int),Error> {
        do {
            let url = type.endpoint + "?page=\(page)"
            let response = try await movieNetwork.fetchMovies(from: url)

            let movieDTOs = response.results
            let movies = movieDTOs.map { Movie(from: $0, isNowPlaying: isNowPlaying) }

            let totalPages = response.totalPages
            return .success((movies: movies, totalPages: totalPages))
        
        } catch {
            return .failure(error)
        }
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
    
    // MARK: - 검색어방식 영화 검색
    func requestData(from query: String, page: Int) async -> Result<[Movie], Error> {
        do {
            let searchResults = try await movieNetwork.searchMovies(query: query, page: page)
            let movies = searchResults.map { Movie(from: $0) }
            return .success(movies)
        } catch {
            return .failure(error)
        }
    }
    
    
}


enum MovieRequestType {
    case nowPlaying
    case upcoming
    case popular
}

extension MovieRequestType {
    var endpoint: String {
        switch self {
        case .nowPlaying: return "\(Constants.BASE_URL)now_playing"
        case .upcoming: return "\(Constants.BASE_URL)upcoming"
        case .popular: return "\(Constants.BASE_URL)popular"
        }
    }
}
