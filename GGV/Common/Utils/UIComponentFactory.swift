//
//  UIComponentFactory.swift
//  GGV
//
//  Created by KimRin on 5/26/25.
//

import UIKit

struct UIComponents {
    
    struct Button {
        static func primary(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = .primaryBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = Constants.UI.cornerRadius
            button.titleLabel?.font = .nanumSquare(size: 17, weight: .extraBold)
            return button
        }
        
        static func secondary(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.primaryBlue, for: .normal)
            button.titleLabel?.font = .nanumSquare(size: 17, weight: .extraBold)
            return button
        }
        
        static func system(title: String, backgroundColor: UIColor = .systemRed) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = backgroundColor
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = .nanumSquare(size: 27, weight: .bold)
            return button
        }
        
        static func icon(title: String, backgroundColor: UIColor, fontSize: CGFloat = 25) -> UIButton {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = backgroundColor
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            button.layer.cornerRadius = 5
            return button
        }
    }
    
    struct Label {
        static func title(_ text: String, size: CGFloat = 20, weight: NanumSquareWeight = .extraBold) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = .nanumSquare(size: size, weight: weight)
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }
        
        static func body(_ text: String, size: CGFloat = 16, weight: NanumSquareWeight = .regular) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = .nanumSquare(size: size, weight: weight)
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }
        
        static func center(_ text: String, size: CGFloat = 18, weight: NanumSquareWeight = .bold) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = .nanumSquare(size: size, weight: weight)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }
        
        static func cell(_ text: String = "", size: CGFloat = 15, weight: NanumSquareWeight = .bold) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = .nanumSquare(size: size, weight: weight)
            label.textColor = .white
            label.textAlignment = .center
            label.backgroundColor = .overlayBlue
            label.numberOfLines = 0
            return label
        }
    }
    
    struct TextField {
        static func standard(placeholder: String, isSecure: Bool = false) -> UITextField {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.isSecureTextEntry = isSecure
            textField.font = .nanumSquare(size: 16)
            return textField
        }
    }
    
    struct ImageView {
        static func create(imageName: String? = nil, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
            let imageView = UIImageView()
            if let imageName = imageName {
                imageView.image = UIImage(named: imageName)
            }
            imageView.contentMode = contentMode
            imageView.clipsToBounds = true
            return imageView
        }
        
        static func rounded(imageName: String? = nil, cornerRadius: CGFloat = 8) -> UIImageView {
            let imageView = create(imageName: imageName, contentMode: .scaleAspectFill)
            imageView.layer.cornerRadius = cornerRadius
            return imageView
        }
    }
    
    struct StackView {
        static func vertical(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .leading) -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = spacing
            stackView.alignment = alignment
            return stackView
        }
        
        static func horizontal(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .center) -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = spacing
            stackView.alignment = alignment
            return stackView
        }
    }
}
