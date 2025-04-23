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
    
  
    //MARK: 현재 상영중인 영화 데이터 가져오기
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[MovieListModel], Error>) -> Void) {
      let urlString = "\(Constants.BASE_URL)now_playing?api_key=\(Constants.API_KEY)&language=ko-KR&page=\(page)&region=KR"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
  
  
  //MARK: MovieDetailView에서 쓸
  func getData<T: Decodable>(endPoint: String, callback: @escaping (T?) -> Void) {
      let session = URLSession(configuration: .default)
      guard let url = URL(string: endPoint) else { return }
      session.dataTask(with: URLRequest(url: url)) { data, response, error in
        guard let resultData = data, error == nil else {
          print("데이터 로드 실패")
          callback(nil)
          return
        }
        let successRange = 200..<300
        if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
          guard let decodedData = try? JSONDecoder().decode(T.self, from: resultData) else {
            print("JSON 디코딩 실패")
            callback(nil)
            return
          }
          callback(decodedData)
        }else {
          print("응답 오류")
          callback(nil)
        }
      }.resume()
    }
    
  func fetchMovies(from endpoint: String, language: String) async -> [MovieListModel] {
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
  }
