//
//  UserService.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

/// 사용자 관련 서비스를 담당하는 클래스
final class UserService {
    // MARK: - 싱글톤 인스턴스
    static let shared = UserService()
    
    private init() {}
    
    // MARK: - 키 상수
      private enum UserDefaultsKeys {
          static let currentUserId = "loggedInUserID"
          static let allReservations = "allReservations"
          static let userPrefix = "user_" // 사용자 정보 저장 시 접두어
      }
      
      // MARK: - 사용자 인증 관련 메서드
      func login(userId: String, password: String) -> Bool {
          guard let user = getUser(userId: userId) else { return false }
          
          let isValidLogin = user.validatePassword(password)
          if isValidLogin {
              // 로그인 성공 시 현재 사용자 ID 저장
              UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.currentUserId)
          }
          
          return isValidLogin
      }
    /// 사용자 로그아웃
     func logout() {
         UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.currentUserId)
     }
    /// 사용자 회원가입
      func signup(username: String, birth: String, userId: String, password: String) -> Bool {
          // 아이디 중복 확인
          if getUser(userId: userId) != nil {
              return false
          }
          
          let user = User(username: username, birth: birth, userId: userId, password: password)
          return saveUser(user)
      }
      
      /// 현재 로그인된 사용자 확인
      /// - Returns: 현재 로그인된 사용자 정보, 없으면 nil
      func getCurrentUser() -> User? {
          guard let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserId) else {
              return nil
          }
          
          return getUser(userId: userId)
      }
    /// 로그인 상태 확인
      /// - Returns: 로그인 되어 있는지 여부
      func isLoggedIn() -> Bool {
          return getCurrentUser() != nil
      }
      
      // MARK: - 사용자 정보 관련 메서드
      private func saveUser(_ user: User) -> Bool {
          do {
              let data = try JSONEncoder().encode(user)
              let userKey = UserDefaultsKeys.userPrefix + user.userId
              UserDefaults.standard.set(data, forKey: userKey)
              return true
          } catch {
              print("Error saving user: \(error)")
              return false
          }
      }
      
      /// 사용자 정보 조회
      private func getUser(userId: String) -> User? {
          let userKey = UserDefaultsKeys.userPrefix + userId
          
          guard let userData = UserDefaults.standard.data(forKey: userKey) else {
              // 이전 버전 호환성을 위한 코드
              if let legacyUserDict = UserDefaults.standard.dictionary(forKey: userId) as? [String: String] {
                  // 기존 방식으로 저장된 데이터를 현재 모델로 변환
                  let user = User(
                      username: legacyUserDict["username"] ?? "",
                      birth: legacyUserDict["userbirth"] ?? "",
                      userId: legacyUserDict["userid"] ?? "",
                      password: legacyUserDict["password"] ?? ""
                  )
                  // 새로운 형식으로 저장
                  _ = saveUser(user)
                  return user
              }
              return nil
          }
          
          do {
              return try JSONDecoder().decode(User.self, from: userData)
          } catch {
              print("Error decoding user: \(error)")
              return nil
          }
      }
      
      // MARK: - 예약 관련 메서드
      
      /// 예약 정보 저장
      func saveReservation(movieId: Int, movieTitle: String, date: String, time: String, people: Int, price: Int, posterPath: String) -> Bool {
          // 현재 로그인한 사용자 확인
          guard getCurrentUser() != nil else {
              return false
          }
          
          // 새 예약 생성
          let reservation = Reservation(
              movieId: movieId,
              movieTitle: movieTitle,
              date: date,
              time: time,
              people: people,
              price: price,
              posterPath: posterPath,
              reservationDate: Date()
          )
          
          // 예약 정보를 UserDefaults에 저장
          var reservations = getAllReservations()
          reservations.insert(reservation, at: 0)  // 최신 예약을 맨 앞에 추가
          
          return saveAllReservations(reservations)
      }
      
      /// 모든 예약 내역 조회
      func getAllReservations() -> [Reservation] {
          // 현재 로그인한 사용자 확인
          guard let currentUser = getCurrentUser() else {
              return []
          }
          
          let reservationsKey = UserDefaultsKeys.allReservations
          
          // UserDefaults에서 예약 내역 가져오기
          guard let reservationsData = UserDefaults.standard.data(forKey: reservationsKey) else {
              // 이전 버전 호환성을 위한 코드
              if let legacyReservations = UserDefaults.standard.array(forKey: reservationsKey) as? [[String: Any]] {
                  // 기존 방식으로 저장된 데이터를 현재 모델로 변환
                  let reservations = legacyReservations.compactMap { dict -> Reservation? in
                      guard let movieId = dict["movieId"] as? Int,
                            let movieTitle = dict["movieTitle"] as? String,
                            let date = dict["date"] as? String,
                            let time = dict["time"] as? String,
                            let people = dict["people"] as? Int,
                            let price = dict["price"] as? Int,
                            let posterPath = dict["posterPath"] as? String else {
                          return nil
                      }
                      
                      return Reservation(
                          movieId: movieId,
                          movieTitle: movieTitle,
                          date: date,
                          time: time,
                          people: people,
                          price: price,
                          posterPath: posterPath,
                          reservationDate: Date()  // 이전 데이터는 현재 시간으로 대체
                      )
                  }
                  
                  // 새로운 형식으로 저장
                  _ = saveAllReservations(reservations)
                  return reservations
              }
              return []
          }
          
          do {
              return try JSONDecoder().decode([Reservation].self, from: reservationsData)
          } catch {
              print("Error decoding reservations: \(error)")
              return []
          }
      }
      
      /// 모든 예약 내역 저장
      private func saveAllReservations(_ reservations: [Reservation]) -> Bool {
          do {
              let reservationsData = try JSONEncoder().encode(reservations)
              UserDefaults.standard.set(reservationsData, forKey: UserDefaultsKeys.allReservations)
              return true
          } catch {
              print("Error saving reservations: \(error)")
              return false
          }
      }
      
      /// 특정 예약 삭제
      func deleteReservation(at index: Int) -> Bool {
          var reservations = getAllReservations()
          guard index >= 0, index < reservations.count else {
              return false
          }
          
          reservations.remove(at: index)
          return saveAllReservations(reservations)
      }
}
