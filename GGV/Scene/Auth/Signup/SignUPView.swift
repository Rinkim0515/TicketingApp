//
//  SignUPView.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit
import SnapKit

class SignUPView: UIView {
  
  private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "회원 가입"
      label.font = UIFont.boldSystemFont(ofSize: 24)
      label.textAlignment = .center
      return label
  }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
  
  let usernameTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "name"
      textField.borderStyle = .roundedRect
      return textField
  }()
    
    let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
  
  let userbirthTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "birth"
      textField.borderStyle = .roundedRect
      return textField
  }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
  
  let useridTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "ID"
      textField.borderStyle = .roundedRect
      return textField
  }()
    
    let pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

  let passwordTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "PW"
      textField.borderStyle = .roundedRect
      return textField
  }()

  

 lazy var signupButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Sign Up", for: .normal)
      button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
      button.setTitleColor(.white, for: .normal)
      button.layer.cornerRadius = 5

      return button
  }()

   lazy var cancelButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Cancel", for: .normal)
      
      return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
      
      self.backgroundColor = .white
    
    [
      titleLabel,
      nameLabel,
      usernameTextField,
      birthLabel,
      userbirthTextField,
      idLabel,
      useridTextField,
      pwLabel,
      passwordTextField,
      signupButton,
      cancelButton
    ].forEach{addSubview($0)}
    

    
    titleLabel.snp.makeConstraints{
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
      
      nameLabel.snp.makeConstraints {
          $0.bottom.equalTo(usernameTextField.snp.top)
          $0.leading.equalTo(usernameTextField.snp.leading)
      }

    usernameTextField.snp.makeConstraints{
      $0.top.equalTo(titleLabel.snp.bottom).offset(90)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
      
      birthLabel.snp.makeConstraints {
          $0.top.equalTo(usernameTextField.snp.bottom).offset(20)
          $0.leading.equalTo(usernameTextField.snp.leading)
      }
      
    userbirthTextField.snp.makeConstraints{
      $0.top.equalTo(birthLabel.snp.bottom)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
      
      idLabel.snp.makeConstraints {
          $0.top.equalTo(userbirthTextField.snp.bottom).offset(20)
          $0.leading.equalTo(usernameTextField.snp.leading)
      }
      
    useridTextField.snp.makeConstraints{
      $0.top.equalTo(idLabel.snp.bottom)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
      
      pwLabel.snp.makeConstraints {
          $0.top.equalTo(useridTextField.snp.bottom).offset(20)
          $0.leading.equalTo(usernameTextField.snp.leading)
      }
      
    passwordTextField.snp.makeConstraints{
      $0.top.equalTo(pwLabel.snp.bottom)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
    signupButton.snp.makeConstraints{
      $0.top.equalTo(passwordTextField.snp.bottom).offset(50)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(120)
      $0.height.equalTo(40)
    }
    cancelButton.snp.makeConstraints{
      $0.top.equalTo(signupButton.snp.bottom).offset(50)
      $0.centerX.equalTo(safeAreaLayoutGuide)
      $0.width.equalTo(120)
      $0.height.equalTo(40)
    }
    
  }
}

