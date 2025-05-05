//
//  CellSection.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation

enum SectionType: Int, CaseIterable {
    case nowPlaying = 0
    case upcoming
    case popular
    
    var title: String {
        switch self {
        case .nowPlaying: return "현재 상영 영화"
        case .upcoming: return "상영 예정 영화"
        case .popular: return "인기 영화"
        }
    }
}

protocol ReusableView: AnyObject {
    static var id: String { get }
}

extension ReusableView {
    static var id: String {
        return String(describing: self)
    }
}
