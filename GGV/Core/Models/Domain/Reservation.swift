//
//  Reservation.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

/// 예약 정보 데이터 모델
struct Reservation: Codable {
    let movieId: Int
    let movieTitle: String
    let date: String
    let time: String
    let people: Int
    let price: Int
    let posterPath: String
    let reservationDate: Date // 예약한 시간
}
