//
//  IndividualModel.swift
//  TeamOne1
//
//  Created by bloom on 7/27/24.
//

import Foundation

class DataController {
    
    // 예약 정보 저장
    static func saveReservationToUserDefaults(date: String, time: String, people: Int, price: Int, movieTitle: String, movieId: Int, posterPath: String) {
        // UserService를 통해 예약 정보 저장
        _ = UserService.shared.saveReservation(
            movieId: movieId,
            movieTitle: movieTitle,
            date: date,
            time: time,
            people: people,
            price: price,
            posterPath: posterPath
        )
    }

    // 모든 예약 정보를 배열로 저장
    static func saveReservationsToUserDefaults(reservations: [[String: Any]], key: String = "allReservations") {
        // 기존 방식을 유지하기 위해 그대로 저장
        UserDefaults.standard.set(reservations, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // 모든 예약 정보를 불러오는 메서드
    static func loadReservationsFromUserDefaults(key: String = "allReservations") -> [[String: Any]]? {
         // UserService를 통해 예약 정보를 가져오되, 호환성을 위해 딕셔너리 형태로 변환
         let reservations = UserService.shared.getAllReservations()
         let reservationDicts: [[String: Any]] = reservations.map { reservation in
             return [
                 "movieId": reservation.movieId,
                 "movieTitle": reservation.movieTitle,
                 "date": reservation.date,
                 "time": reservation.time,
                 "people": reservation.people,
                 "price": reservation.price,
                 "posterPath": reservation.posterPath
             ]
         }
         
         return reservationDicts.isEmpty ? UserDefaults.standard.array(forKey: key) as? [[String: Any]] : reservationDicts
     }
    
}


