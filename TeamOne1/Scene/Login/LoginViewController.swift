//
//  ViewController.swift
//  TeamOne1
//
//  Created by bloom on 7/22/24.
//

import UIKit
import SnapKit
final class LoginViewController: UIViewController {

  
  let loginView = LoginView()
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureAddTarget()

    view.addSubview(loginView)
    loginView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }

  
  private func configureAddTarget(){
    loginView.signupButton.addTarget(self, action: #selector(signupTapped), for: .touchDown)
    loginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchDown)
  }


    @objc private func loginTapped() {
        // 로그인 로직 구현
        guard let userid = loginView.idTextField.text, !userid.isEmpty,
              let password = loginView.pwTextField.text, !password.isEmpty else {
            showAlert(message: "아이디와 비밀번호를 입력해주세요.")
            return
        }
        
        if let userDict = UserDefaults.standard.dictionary(forKey: userid) as? [String: String],
               userDict["password"] == password {
            // 로그인 성공 시 아이디 저장
            UserDefaults.standard.set(userid, forKey: "loggedInUserID")
              showAlert(message: "로그인 성공") {
                // 로그인 성공 시 메인화면 전환
                let tabBarController = MainController()
                  self.navigationController?.pushViewController(tabBarController, animated: true)
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
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
