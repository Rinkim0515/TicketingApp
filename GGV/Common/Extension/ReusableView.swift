//
//  CellSection.swift
//  GGV
//
//  Created by KimRin on 5/5/25.
//

import Foundation



protocol ReusableView: AnyObject {
    static var id: String { get }
}

extension ReusableView {
    static var id: String {
        return String(describing: self)
    }
}
