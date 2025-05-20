//
//  User.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

/// 사용자 관련 데이터 모델
struct User: Codable {
    let username: String
    let birth: String
    let userId: String
    private let password: String
    
    init(username: String, birth: String, userId: String, password: String) {
        self.username = username
        self.birth = birth
        self.userId = userId
        self.password = password
    }
    
    func validatePassword(_ input: String) -> Bool {
        return password == input
    }
}
