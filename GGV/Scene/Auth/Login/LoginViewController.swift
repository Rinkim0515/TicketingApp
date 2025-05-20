//
//  ViewController.swift
//  TeamOne1
//
//  Created by bloom on 7/22/24.
//
// 로그인 창위에 signUP화면을 올리고 그것에 대한 권한은 로그인 VC에서 받아서 처리하고 회원가입이 되면 방금 가입한 아이디로 로그인 시켜주자


import UIKit
import SnapKit
final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let loginView = LoginView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddTarget()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Event Handling
    private func configureAddTarget() {
        loginView.signupButton.addTarget(self, action: #selector(signupTapped), for: .touchDown)
        loginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchDown)
    }
    
    @objc private func loginTapped() {
        // 입력값 검증
        guard let userid = loginView.idTextField.text, !userid.isEmpty,
              let password = loginView.pwTextField.text, !password.isEmpty else {
            showAlert(message: "아이디와 비밀번호를 입력해주세요.")
            return
        }
        
        // UserService를 통한 로그인 처리
        if UserService.shared.login(userId: userid, password: password) {
            showAlert(message: "로그인 성공") {
                self.navigateToMainScreen()
            }
        } else {
            showAlert(message: "아이디 또는 비밀번호가 잘못되었습니다.")
        }
    }
    
    @objc private func signupTapped() {
        let signupViewController = SignupViewController()
        signupViewController.modalPresentationStyle = .fullScreen
        present(signupViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    private func navigateToMainScreen() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else { return }
        
        let mainVC = MainViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
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
