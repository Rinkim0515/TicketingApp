//
//  SignupViewController.swift
//  TeamOne1
//
//  Created by 내꺼다 on 7/22/24.
//

import UIKit
import SnapKit

final class SignupViewController: UIViewController {
    // MARK: - Properties
    let signUpView = SignUPView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBasic()
    }
    
    // MARK: - UI Setup
    private func configureBasic() {
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        signUpView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        signUpView.signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Handling
    @objc private func signupTapped() {
        // 입력값 유효성 검사
        guard let username = signUpView.usernameTextField.text, !username.isEmpty,
              let userbirth = signUpView.userbirthTextField.text, !userbirth.isEmpty,
              let userid = signUpView.useridTextField.text, !userid.isEmpty,
              let password = signUpView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "모든 항목을 채워주세요.")
            return
        }
        
        // 추가 유효성 검사 가능
        // 1. 비밀번호 길이
        guard password.count >= 6 else {
            showAlert(message: "비밀번호는 최소 6자리 이상이어야 합니다.")
            return
        }
        
        // 2. 생년월일 형식 검사 (예시)
        let birthPattern = "^\\d{4}[./-]?\\d{2}[./-]?\\d{2}$"
        let birthPredicate = NSPredicate(format: "SELF MATCHES %@", birthPattern)
        guard birthPredicate.evaluate(with: userbirth) else {
            showAlert(message: "생년월일 형식이 올바르지 않습니다. (YYYY.MM.DD)")
            return
        }
        
        // UserService를 통한 회원가입 처리
        if UserService.shared.signup(username: username, birth: userbirth, userId: userid, password: password) {
            showAlert(message: "회원 가입 완료") {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            showAlert(message: "이미 사용 중인 아이디입니다.")
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
