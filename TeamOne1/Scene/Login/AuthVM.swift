//
//  AuthVM.swift
//  TeamOne1
//
//  Created by KimRin on 4/23/25.
//

import Foundation

final class AuthVM {
    
    //SignUp 시 UserDefaults 추가
    //login시 UserDefaults에서 validation 필요
    // 이름이나 생년월일등등 조건검사 필요
    // 아이디 중복 조회 (회원가입시)
    // 공백체크
    //이메일 형태 @ 포함 앞뒤 체크
    // 비밀번호 6자리 이상
    // 공백 제한
    // 비밀번호 확인 여부
    //입력시마다 유효성의 실시간 표시
    // 자동포커싱 이메일 입력후 비밀번호로 자동이동 키보드에서 리턴을 누를시 다음 텍스트필드로의 이동
    //실시간 오류 메세지 " 이메일 형식이 잘못되었습니다" 와 같은방식 
    //키보드 리턴 처림
    //키보드 자동 dismiss
    //
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
