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

class MovieRepository: ObservableObject {
    static let shared = MovieRepository()
    let movieNetwork = MovieNetwork.shared
    //MARK: - MovieProperty
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var upcommingMovies: [Movie] = []
    @Published var searchMovies: [Movie] = []
    //MARK: -
    var nowPlayingCurrentPage: Int = 1
    var nowPlayingTotalPages: Int?
    
    var popularCurrentPage: Int = 1
    var popularTotalPages: Int?
    
    var upcommingCurrentPage: Int = 1
    var upcommingTotalPages: Int?
    
    var searchMoviesCurrentPage: Int = 1
    var searchMoviesTotalPages: Int?
    
    
    private init() {
        
    }
    
    
    
    //MARK: - 상영중 영화리스트 초기/ 추가 호출
    func fetchNowplayingMovies(loadMore: Bool = false) async {
        // 초기 호출인지 / 추가 호출인지 검사
        let nextPage = loadMore ? nowPlayingCurrentPage + 1 : 1
        // 페이지상태에 문제가없는지 검사
        if let total = nowPlayingTotalPages, nextPage > total { return }
        //페이지 값과함께 데이터 호출
        let result = await requestData(type: .nowPlaying, page: nextPage, isNowPlaying: true)
        //결과에따른 데이터 할당 혹은 추가
        switch result {
        case .success(let (movies, totalPages)):
            nowPlayingMovies = loadMore ? nowPlayingMovies + movies : movies
            nowPlayingCurrentPage = nextPage
            nowPlayingTotalPages = totalPages
        case .failure(let error):
            print("❗️상영 중 영화 로딩 실패: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - 인기영화 초기/추가 호출
    func fetchPopularMovies(loadMore: Bool = false) async {
        let nextPage = loadMore ? popularCurrentPage + 1 : 1
        if let total = popularTotalPages, nextPage > total { return }
        
        let result = await requestData(type: .popular, page: nextPage)
        switch result {
        case .success(let (movies, totalPages)):
            popularMovies = loadMore ? popularMovies + movies : movies
            popularCurrentPage = nextPage
            popularTotalPages = totalPages
        case .failure(let error):
            print("❗️인기 영화 로딩 실패: \(error.localizedDescription)")
            if !loadMore { popularMovies = [] }
        }
    }
    //MARK: - 상영예정작 초기/추가 호출
    func fetchUpcomingMovies(loadMore: Bool = false) async {
        let nextPage = loadMore ? upcommingCurrentPage + 1 : 1
        if let total = upcommingTotalPages, nextPage > total { return }
        
        let result = await requestData(type: .upcoming, page: nextPage)
        switch result {
        case .success(let (movies, totalPages)):
            upcommingMovies = loadMore ? upcommingMovies + movies : movies
            upcommingCurrentPage = nextPage
            upcommingTotalPages = totalPages
        case .failure(let error):
            print("❗️상영 예정 영화 로딩 실패: \(error.localizedDescription)")
            if !loadMore { upcommingMovies = [] }
        }
    }
    
    //MARK: - 검색어 기반 초기/ 추가 호출
    func fetchSearchMovies(query: String, loadMore: Bool = false) async {
        let nextPage = loadMore ? searchMoviesCurrentPage + 1 : 1
        if let total = searchMoviesTotalPages, nextPage > total { return }
        
        let result = await requestData(from: query, page: nextPage)
        switch result {
        case .success(let movies):
            searchMovies = loadMore ? searchMovies + movies : movies
            searchMoviesCurrentPage = nextPage
        case .failure(let error):
            print("❗️검색 결과 로딩 실패: \(error.localizedDescription)")
            if !loadMore { searchMovies = [] }
        }
    }

    //MARK: - 상영작내에서 검색을 하기위한 데이터 호출
    func fetchAllNowPlayingMovies() async {
        
        if nowPlayingCurrentPage > 1, let totalPages = nowPlayingTotalPages {
            var page = nowPlayingCurrentPage + 1
            while page <= totalPages {
                let result = await requestData(type: .nowPlaying, page: page, isNowPlaying: true)
                switch result {
                case .success(let (movies, _)):
                    nowPlayingMovies += movies
                    nowPlayingCurrentPage = page
                    page += 1
                case .failure(let error):
                    print("❗️상영 중 전체 로딩 실패 (추가 페이지): \(error.localizedDescription)")
                    return
                }
            }
            return
        }

        //만약에라도 페이지 1이 호출이되지않은상황이라고 한다면
        nowPlayingMovies = []
        nowPlayingCurrentPage = 1
        nowPlayingTotalPages = nil
        var page = 1
        while true {
            let result = await requestData(type: .nowPlaying, page: page, isNowPlaying: true)
            switch result {
            case .success(let (movies, totalPages)):
                nowPlayingMovies += movies
                nowPlayingTotalPages = totalPages
                nowPlayingCurrentPage = page
                if page >= totalPages {
                    return
                }
                page += 1
            case .failure(let error):
                print("❗️상영 중 전체 로딩 실패: \(error.localizedDescription)")
                return
            }
        }
    }


    
    
    //MARK: - 키워드방식 정보 호출
    func requestData(type: MovieRequestType, page: Int = 1, isNowPlaying: Bool = false) async -> Result<([Movie],totalPages: Int),Error> {
        do {
            let url = type.endpoint + "?page=\(page)"
            let response = try await movieNetwork.fetchMovieList(page: page, type: type)
            let movieDTOs = response.results
            let movies = movieDTOs.map { Movie(from: $0, isNowPlaying: isNowPlaying) }
            guard let totalPages = response.totalPages else {
                return .failure(URLError(.cannotParseResponse))
            }
            
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
