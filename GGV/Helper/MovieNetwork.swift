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
    
    
    //MARK: 현재 상영중인 영화 데이터 가져오기 얘 그냥 페이징이긴한데 다 때려박는 코드인거같음 모두 호출해서 페이징으로 늘리기만함
    // 어떻게 해결? -> 모든 영화검색기반으로 할것인지
    func fetchNowPlayingMovies(page: Int) async throws -> [MovieListModel] {
        
        let urlString = "\(Constants.BASE_URL)now_playing"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "region", value: "KR")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZmMzMWE5MTc2MTBjNTM2MWQ4YTIyZWMxMmRjNWZlMyIsIm5iZiI6MTcyMTcwNzczNS41Mjc3MTIsInN1YiI6IjY2OWYyYWE1NGI0OTYxOGI0OTJlNzY3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.waKjweehRkNo-6V380n0VBdkrGWv998aIu-2Zk82-Bw"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse.results


    }
    
    func search (){}
    
    
    //MARK: MovieDetailView에서 쓸
    
    func getData(movieId: Int) async -> MovieDetailModel? {
        
        let detailurl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=4e7d627f53b0470f38e13533b907923c&language=ko-KR")
        
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
    
    
    func fetchMovies(from endpoint: String, language: String = "ko-KR") async -> [MovieListModel] {
        let url = URL(string: endpoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "1"),
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZmMzMWE5MTc2MTBjNTM2MWQ4YTIyZWMxMmRjNWZlMyIsIm5iZiI6MTcyMTcwNzczNS41Mjc3MTIsInN1YiI6IjY2OWYyYWE1NGI0OTYxOGI0OTJlNzY3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.waKjweehRkNo-6V380n0VBdkrGWv998aIu-2Zk82-Bw"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieResponse.self, from: data)
            return response.results
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
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
