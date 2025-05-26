//
//  SearchMovieNetwork.swift
//  TeamOne1
//
//  Created by 유민우 on 7/25/24.
//
// 메타데이터 때문에 list형식으로 받아오는것은 Response로 받아서 매핑하는 방식 선택
//

import Foundation

final class MovieNetwork {
    static let shared = MovieNetwork() // 싱글톤 패턴
    
    
    
    func fetchMovieList(page: Int, type: MovieCategory) async throws -> MovieResponseDTO {
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
        let movieResponse = try JSONDecoder().decode(MovieResponseDTO.self, from: data)
        return movieResponse
    }
    
    
    
    
    
    func fetchMovieDetailInfo(movieId: Int) async throws -> MovieDetailDTO? {
        guard let detailurl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constants.API_KEY)&language=ko-KR")
                
        else {
            print("잘못된 URL 형식")
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: detailurl)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("서버 응답 에러")
                return nil
            }
            let decodedData = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
            return decodedData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    
    
    
    // Async/await 기반 영화 검색 함수
    func searchMovies(query: String, page: Int = 1) async throws -> MovieResponseDTO {
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
        
        let movieResponse = try JSONDecoder().decode(MovieResponseDTO.self, from: data)
        return movieResponse
    }
}
