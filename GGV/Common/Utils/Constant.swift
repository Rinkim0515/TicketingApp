//
//  Constant.swift
//  GGV
//
//  Created by KimRin on 5/26/25.
//

import Foundation

struct Constants {
    static let API_KEY = "4e7d627f53b0470f38e13533b907923c"
    static let BASE_URL = "https://api.themoviedb.org/3/movie/"
    
    // 추가할 상수들
    struct UI {
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let standardSpacing: CGFloat = 10
        static let largeSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let cellHeight: CGFloat = 220
    }
    
    struct Movie {
        static let ticketPrice = 14000
        static let minimumPeople = 1
        static let posterAspectRatio: CGFloat = 1.5
    }
    
}
