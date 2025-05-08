//
//  SearchMovieNetwork.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
//

// 영화 검색 페이지에서 사용할 네트워크 -> 가져오기
import Foundation

struct Constants {
    static let API_KEY = "4e7d627f53b0470f38e13533b907923c"
    static let BASE_URL = "https://api.themoviedb.org/3/movie/"
}




final class MovieNetwork {
    static let shared = MovieNetwork() // 싱글톤 패턴
    
    
    
    //MARK: - TotalPage를 위한
    func fetchMovieList(page: Int, type: MovieRequestType) async throws -> MovieResponse {
        guard var components = URLComponents(string: type.endpoint) else {
            throw URLError(.badURL)
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_KEY),
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "region", value: "KR"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        
        return movieResponse
    }
    
    
    
    
    //MARK: MovieDetailView에서 쓸
    
    func fetchMovieDetailInfo(movieId: Int) async throws -> MovieDetailModel? {
        let detailurl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constants.API_KEY)&language=ko-KR")
        do {
            let (data, response) = try await URLSession.shared.data(from: detailurl!)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("서버 응답 에러")
                return nil
            }
            let decodedData = try JSONDecoder().decode(MovieDetailModel.self, from: data)
            return decodedData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    
    
    
    // Async/await 기반 영화 검색 함수
    func searchMovies(query: String, page: Int = 1) async throws -> [MovieListModel] {
        let baseURL = "https://api.themoviedb.org/3/search/movie"
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_KEY),
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "region", value: "KR")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse.results
    }
}
