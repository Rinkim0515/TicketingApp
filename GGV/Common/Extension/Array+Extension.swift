//
//  Array+Extension.swift
//  GGV
//
//  Created by KimRin on 5/20/25.
//

import Foundation

extension Array where Element == Int {
    func genreNames() -> [String] {
        return self.compactMap { Genre(rawValue: $0)?.name }
    }
}
