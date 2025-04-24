//
//  SignupViewController.swift
//  TeamOne1
//
//  Created by 내꺼다 on 7/22/24.
//

import UIKit
import SnapKit

final class SignupViewController: UIViewController {
    let signUpView = SignUPView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBasic()
    }

    final private func configureBasic() {
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        signUpView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        signUpView.signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }

    @objc private func signupTapped() {
        // 유효성검사
      
        guard let username = signUpView.usernameTextField.text, !username.isEmpty,
              let userbirth = signUpView.userbirthTextField.text, !userbirth.isEmpty,
              let userid = signUpView.useridTextField.text, !userid.isEmpty,
              let password = signUpView.passwordTextField.text, !password.isEmpty
              
      else {
            
          showAlert(message: "모든 항목을 채워주세요.")
            return
        }

        // 유효성 검사를 통과한 후 UserDefaults에 저장
        let userDict: [String: String] = [
            "username": username,
            "userbirth": userbirth,
            "userid": userid,
            "password": password
            
            
        ]
        UserDefaults.standard.set(userDict, forKey: userid)
        UserDefaults.standard.synchronize()

        showAlert(message: "회원 가입 완료", completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
