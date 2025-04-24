//
//  LoginView.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit

final class LoginView: UIView {
    
  private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GGV")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
  
  lazy var idTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "id"
      textField.borderStyle = .roundedRect
      return textField
  }()
  
  lazy var pwTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "pw"
      textField.borderStyle = .roundedRect
      textField.isSecureTextEntry = true
      return textField
  }()
  
  lazy var loginButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("로그인", for: .normal)
      button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
      button.setTitleColor(.white, for: .normal)
      button.layer.cornerRadius = 5
      button.titleLabel?.font = UIFont(name: "NanumSquareNeo-dEb", size: 17)
      return button
  }()

  lazy var signupButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("회원가입", for: .normal)
      button.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), for: .normal)
      button.titleLabel?.font = UIFont(name: "NanumSquareNeo-dEb", size: 17)
      return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  private func configureUI() {
      self.backgroundColor = .white
    [
      logoImageView,
      idTextField,
      pwTextField,
      loginButton,
      signupButton
    ].forEach{addSubview($0)}
    
    logoImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
      $0.width.equalTo(300)
      $0.height.equalTo(300)
      }
    
    idTextField.snp.makeConstraints{
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(logoImageView.snp.bottom).offset(5)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
    pwTextField.snp.makeConstraints{
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(idTextField.snp.bottom).offset(20)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
    loginButton.snp.makeConstraints{
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(pwTextField.snp.bottom).offset(50)
      $0.width.equalTo(120)
      $0.height.equalTo(40)
    }
    signupButton.snp.makeConstraints{
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(loginButton.snp.bottom).offset(15)
      $0.width.equalTo(loginButton)
      $0.height.equalTo(loginButton)
    }
    
    
    

      
  }
}

