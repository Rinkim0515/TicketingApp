//
//  UIFont+Extension.swift
//  GGV
//
//  Created by KimRin on 5/26/25.
//

import UIKit

extension UIFont {
    static func nanumSquare(size: CGFloat, weight: NanumSquareWeight = .regular) -> UIFont {
        let fontName: String
        switch weight {
        case .regular: fontName = "NanumSquareNeo-bRg"
        case .bold: fontName = "NanumSquareNeo-cBd"
        case .extraBold: fontName = "NanumSquareNeo-dEb"
        }
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
    }
}

enum NanumSquareWeight {
    case regular, bold, extraBold
}
