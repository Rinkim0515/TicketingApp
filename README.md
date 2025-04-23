# 🎬 TMDB Auth Movie App

TMDB 영화 API와 Firebase Authentication을 활용한 간단한 영화 검색 앱입니다.  
Swift Concurrency의 `Task`, `async/await`를 활용한 비동기 흐름과 MVVM-lite 구조를 기반으로 구현되었습니다.

---

## 📱 주요 기능

- Firebase 이메일/비밀번호 로그인 & 로그아웃
- 로그인 상태 유지 (자동 로그인)
- TMDB 영화 목록 비동기 호출 및 UI 반영
- Task 기반의 비동기 흐름 처리

---

## 🧱 기술 스택

| 구성 | 기술 |
|------|------|
| UI | UIKit |
| 비동기 처리 | Swift Concurrency (Task, async/await) |
| 아키텍처 | MVVM-lite |
| 인증 | Firebase Authentication |
| API | TMDB API (URLSession) |

---

## 🧩 아키텍처 구성

```bash
TMDBAuthMovieApp
├── Models
├── ViewModels
│   ├── AuthViewModel.swift
│   └── MovieViewModel.swift
├── Views
│   ├── LoginViewController.swift
│   └── MovieListViewController.swift
├── Network
│   └── TMDBService.swift
```

---

## 🔁 주요 흐름

1. 사용자 로그인 (Firebase)
2. 로그인 성공 시 홈 화면 전환
3. 홈 화면에서 TMDB API 호출
4. 로그아웃 시 로그인 화면 복귀

---

## 💡 설계 포인트

- MVVM-lite 구조로 View ↔ ViewModel 분리
- 클로저 기반의 바인딩 (Rx/Combine 없음)
- `@MainActor` 또는 `DispatchQueue.main.async`를 통한 UI 스레드 안전성 확보
- async/await로 순차적이고 가독성 높은 로직 구성

---

## 🚀 향후 확장 방향

- 사용자 프로필 정보 연동
- 즐겨찾기 기능 추가 (Firestore 연동)
- 검색 기능 추가

---

## 📄 참고 API

- [TMDB 공식 문서](https://developer.themoviedb.org/)
- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)

---

© 2024 by [Your Name]
