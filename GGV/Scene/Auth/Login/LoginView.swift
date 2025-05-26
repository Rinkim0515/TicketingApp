//
//  LoginView.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit

final class LoginView: UIView {
    
  private let logoImageView: UIImageView = UIComponents.ImageView.create(imageName: "GGV")
  lazy var idTextField: UITextField = UIComponents.TextField.standard(placeholder: "id")
  lazy var pwTextField: UITextField = UIComponents.TextField.standard(placeholder: "pw", isSecure: true)
  lazy var loginButton: UIButton = UIComponents.Button.primary(title: "로그인")
  lazy var signupButton: UIButton = UIComponents.Button.secondary(title: "회원가입")
  
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

