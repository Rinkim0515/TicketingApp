//
//  UIComponentFactory.swift
//  GGV
//
//  Created by KimRin on 5/26/25.
//

import UIKit
struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    
    // 기준 화면 크기 (iPhone 12 기준)
    private static let baseWidth: CGFloat = 390
    private static let baseHeight: CGFloat = 844
    
    // 화면 크기 분류
    static let isSmallScreen = width <= 375  // iPhone SE, 12 mini
    static let isMediumScreen = width <= 414 // iPhone 12, 13, 14
    static let isLargeScreen = width > 414   // iPhone Pro Max 시리즈
    
    // 비율에 따른 동적 크기 계산
    static func scaled(_ value: CGFloat) -> CGFloat {
        return (width / baseWidth) * value
    }
    
    static func heightScaled(_ value: CGFloat) -> CGFloat {
        return (height / baseHeight) * value
    }
    
    // 최소/최대 제한이 있는 스케일링
    static func scaledWithLimits(_ value: CGFloat, min: CGFloat? = nil, max: CGFloat? = nil) -> CGFloat {
        var scaledValue = scaled(value)
        
        if let minValue = min {
            scaledValue = Swift.max(scaledValue, minValue)
        }
        
        if let maxValue = max {
            scaledValue = Swift.min(scaledValue, maxValue)
        }
        
        return scaledValue
    }
}


struct UIComponentFactory {
    
    // MARK: - Button Factory
    static func createPrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.UI.cornerRadius
        button.titleLabel?.font = .nanumSquare(size: ScreenSize.scaledWithLimits(17, min: 15, max: 19), weight: .extraBold)
        return button
    }
    
    static func createSecondaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.primaryBlue, for: .normal)
        button.titleLabel?.font = .nanumSquare(size: ScreenSize.scaledWithLimits(17, min: 15, max: 19), weight: .extraBold)
        return button
    }
    
    static func createSystemButton(title: String, backgroundColor: UIColor = .systemRed) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = ScreenSize.scaled(10)
        button.titleLabel?.font = .nanumSquare(size: ScreenSize.scaledWithLimits(27, min: 22, max: 30), weight: .bold)
        return button
    }
    
    // MARK: - TextField Factory
    static func createStandardTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.font = .nanumSquare(size: ScreenSize.scaledWithLimits(16, min: 14, max: 18))
        return textField
    }
    
    // MARK: - Label Factory
    static func createTitleLabel(text: String, size: CGFloat = 20) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .nanumSquare(size: ScreenSize.scaledWithLimits(size, min: size - 4, max: size + 4), weight: .extraBold)
        label.textAlignment = .left
        return label
    }
    
    static func createBodyLabel(text: String, size: CGFloat = 16) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .nanumSquare(size: ScreenSize.scaledWithLimits(size, min: size - 2, max: size + 2), weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }
    
    static func createBoldLabel(text: String, size: CGFloat = 17) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .nanumSquare(size: ScreenSize.scaledWithLimits(size, min: size - 2, max: size + 2), weight: .bold)
        label.textAlignment = .left
        return label
    }
    
    // MARK: - ImageView Factory
    static func createImageView(imageName: String? = nil, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let imageView = UIImageView()
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        return imageView
    }
    
    static func createRoundedImageView(imageName: String? = nil, cornerRadius: CGFloat = 8) -> UIImageView {
        let imageView = createImageView(imageName: imageName, contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = ScreenSize.scaled(cornerRadius)
        return imageView
    }
    
    // MARK: - StackView Factory
    static func createVerticalStackView(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .leading) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = ScreenSize.scaled(spacing)
        stackView.alignment = alignment
        return stackView
    }
    
    static func createHorizontalStackView(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .center) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = ScreenSize.scaled(spacing)
        stackView.alignment = alignment
        return stackView
    }
    
    // MARK: - Container View Factory
    static func createCardView(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 8) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = ScreenSize.scaled(cornerRadius)
        view.layer.borderWidth = Constants.UI.borderWidth
        view.layer.borderColor = UIColor.borderBlue
        view.clipsToBounds = true
        return view
    }
}
