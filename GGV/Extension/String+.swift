//
//  String+.swift
//  GGV
//
//  Created by KimRin on 5/19/25.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = format
        return df.date(from: self)
    }
}
