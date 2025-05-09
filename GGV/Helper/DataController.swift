//
//  IndividualModel.swift
//  TeamOne1
//
//  Created by bloom on 7/27/24.
//

import Foundation

class DataController {

    
    // 예약 정보를 UserDefaults에 저장하는 메서드
    // 이부분을 FireBase로 저장 처리를 해줘야함
    static func saveReservationToUserDefaults(date: String, time: String, people: Int, price: Int, movieTitle: String, movieId: Int, posterPath: String) {
        // 딕셔너리로 변환
        let reservationDict: [String: Any] = [
            "movieId": movieId,
            "movieTitle": movieTitle,
            "date": date,
            "time": time,
            "people": people,
            "price": price,
            "posterPath": posterPath
        ]
        
        // UserDefaults에 저장
        var allReservations = loadReservationsFromUserDefaults(key: "allReservations") ?? []
        allReservations.insert(reservationDict, at: 0)
        saveReservationsToUserDefaults(reservations: allReservations, key: "allReservations")
    }

    // 모든 예약 정보를 배열로 저장
    static func saveReservationsToUserDefaults(reservations: [[String: Any]], key: String) {
        UserDefaults.standard.set(reservations, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // 모든 예약 정보를 불러오는 메서드
    static func loadReservationsFromUserDefaults(key: String) -> [[String: Any]]? {
        return UserDefaults.standard.array(forKey: key) as? [[String: Any]]
    }
    
}


