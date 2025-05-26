//
//  SignUPView.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit
import SnapKit

final class SignupView: UIView {
    
    private let titleLabel: UILabel =  UIComponents.Label.title("회원 가입", size: 24)
    private  let nameLabel: UILabel = UIComponents.Label.body("이름", size: 17, weight: .bold)
    private let birthLabel: UILabel = UIComponents.Label.body("생년월일", size: 17, weight: .bold)
    private let idLabel: UILabel = UIComponents.Label.body("아이디", size: 17, weight: .bold)
    private let pwLabel: UILabel = UIComponents.Label.body("비밀번호", size: 17, weight: .bold)
    
    let usernameTextField: UITextField = UIComponents.TextField.standard(placeholder: "name")
    let birthTextField: UITextField = UIComponents.TextField.standard(placeholder: "birth")
    let userIdTextField: UITextField = UIComponents.TextField.standard(placeholder: "ID")
    let passwordTextField: UITextField = UIComponents.TextField.standard(placeholder: "PW")
    lazy var signupButton: UIButton = UIComponents.Button.primary(title: "Sign Up")
    lazy var cancelButton: UIButton = UIComponents.Button.secondary(title: "Cancel")
    
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
            birthTextField,
            idLabel,
            userIdTextField,
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
        
        birthTextField.snp.makeConstraints{
            $0.top.equalTo(birthLabel.snp.bottom)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(birthTextField.snp.bottom).offset(20)
            $0.leading.equalTo(usernameTextField.snp.leading)
        }
        
        userIdTextField.snp.makeConstraints{
            $0.top.equalTo(idLabel.snp.bottom)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        pwLabel.snp.makeConstraints {
            $0.top.equalTo(userIdTextField.snp.bottom).offset(20)
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

