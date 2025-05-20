//
//  LaunchScreenVC.swift
//  GGV
//
//  Created by KimRin on 5/9/25.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "GGV")) // 로고 이미지
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 1초 후 로그인 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)

            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first else {
                print("윈도우를 찾을 수 없습니다.")
                return
            }

            window.rootViewController = nav
            window.makeKeyAndVisible()

            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
    }
}
