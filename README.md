# GGV - 영화 예매 애플리케이션

GGV는 영화 정보를 탐색하고 예매할 수 있는 iOS 애플리케이션입니다. TMDB API를 활용하여 현재 상영 중인 영화, 개봉 예정 영화, 인기 영화 등의 정보를 제공하며, 사용자는 영화를 검색하고 예매할 수 있습니다.


## 주요 기능

- **영화 탐색**: 현재 상영 중인 영화, 개봉 예정 영화, 인기 영화를 탐색할 수 있습니다.
- **영화 검색**: 특정 영화를 검색하고 상세 정보를 확인할 수 있습니다.
- **영화 상세 정보**: 영화의 줄거리, 평점, 출시일 등 상세 정보를 제공합니다.
- **예매 시스템**: 영화 예매, 날짜 및 시간 선택, 인원 설정 기능을 제공합니다.
- **사용자 계정**: 회원가입, 로그인 및 예매 내역 관리 기능을 제공합니다.



## 기술 스택

- **언어**: Swift
- **아키텍처**: MVVM (Model-View-ViewModel)
- **UI 프레임워크**: UIKit, SnapKit
- **비동기 프로그래밍**: Combine, Swift Concurrency (async/await)
- **네트워크**: URLSession
- **이미지 캐싱**: Kingfisher
- **데이터 저장**: UserDefaults
- **API**: TMDB (The Movie Database)

---

## 아키텍처

이 애플리케이션은 MVVM 아키텍처와 함께 Clean Architecture의 원칙을 적용하여 설계되었습니다.

### 주요 레이어:

- **Presentation Layer**: View Controllers, Views, ViewModels
- **Domain Layer**: 비즈니스 로직, Models
- **Data Layer**: Repositories, Network Services


### 폴더 구조:
```bash
GGV/
├── App/ (앱 진입점)
├── Scenes/ (화면별 구성)
│   ├── Main/ (탭바 컨트롤러)
│   ├── Movies/ (영화 관련 화면)
│   ├── Auth/ (인증 관련 화면)
│   └── MyPage/ (마이페이지 화면)
├── Core/ (핵심 로직)
│   ├── Models/ (데이터 모델)
│   ├── Services/ (비즈니스 로직)
│   ├── Network/ (네트워크 처리)
│   └── Storage/ (로컬 저장소)
├── Common/ (공통 기능)
│   ├── Extensions/
│   └── Utils/
└── Resources/ (리소스 파일)
```


## 비동기 처리 전략

애플리케이션은 두 가지 주요 비동기 처리 방식을 사용합니다:

1. **Combine**: 데이터 바인딩과 UI 업데이트에 활용
2. **Swift Concurrency (async/await)**: 네트워크 요청 및 비동기 작업 처리에 활용

특히 최신 Swift 동시성 기능을 적극 활용하여 가독성 높은 비동기 코드를 작성했습니다.

## 주요 화면

### 영화 목록 화면
- 수평 스크롤 가능한 영화 카드 목록
- 페이징을 통한 효율적인 데이터 로드
- 컴포지셔널 레이아웃을 활용한 UI 구성

### 영화 검색 화면
- 실시간 검색 결과 표시
- 효율적인 네트워크 요청 관리
- 로컬 필터링 및 네트워크 검색 지원

### 영화 상세 화면
- 영화 포스터 및 상세 정보 표시
- 현재 상영 여부에 따른 예매 버튼 활성화/비활성화
- Kingfisher를 활용한 효율적인 이미지 로딩

### 예매 화면
- 날짜 및 시간 선택 피커
- 인원 수 조정 및 가격 계산
- 예매 정보 저장 및 확인 기능

### 마이페이지
- 사용자 정보 표시
- 예매 내역 확인
- 로그아웃 기능


## 코드 하이라이트

### MVVM 패턴 구현
```swift
// ViewModel 예시
final class MovieListVM {
    @Published var nowPlayingCardModels: [MovieCardCellModel] = []
    @Published var upcomingBannerModels: [MovieBannerCellModel] = []
    @Published var popularCardModels: [MovieCardCellModel] = []
    
    func loadInitialSections() async {
        async let now: () = loadNextPageIfNeeded(for: .nowPlaying)
        async let pop: () = loadNextPageIfNeeded(for: .popular)
        async let upc: () = loadNextPageIfNeeded(for: .upcoming)
        _ = await [now, pop, upc]
    }
    
    // ... 기타 메서드
```
### Swift Concurrency를 활용한 비동기 처리
```swift
// 비동기 데이터 로딩 예시
private func loadMovies(for type: MovieCategory) async {
    guard await loadingState.checkAndSetLoading(for: type) else { return }
    let result = await repository.fetchMovies(by: type, page: currentPageByCategory[type, default: 1])
    await MainActor.run {
        // UI 업데이트 코드
    }
    await loadingState.setFinished(for: type)
}
```
### Combine을 활용한 데이터 바인딩
```swift
// Combine을 활용한 ViewModel 바인딩 예시
private func bindViewModel() {
    Publishers.CombineLatest3(viewModel.$nowPlayingCardModels, 
                             viewModel.$upcomingBannerModels, 
                             viewModel.$popularCardModels)
        .map { [weak self] nowPlaying, upcoming, popular -> (...) }
        .compactMap { $0 }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] tuple in
            self?.applySnapshot(...)
        }
        .store(in: &cancellables)
}
```

## 배운 점 및 개선 사항
### 구현 과정에서 배운 점
- MVVM 아키텍처를 활용한 관심사 분리
- Combine과 Swift Concurrency를 함께 사용하는 효과적인 방법
- UICollectionView와 Compositional Layout을 활용한 복잡한 UI 구현
- Actor를 활용한 상태 관리 및 동시성 제어
### 향후 개선 사항
- Unit Test 및 UI Test 추가
- 메모리 관리 최적화
- SwiftUI로의 점진적 마이그레이션
- CoreData를 활용한 로컬 데이터 저장 개선
- 디자인 시스템 구축
### 개발자

- 이름: [김리인]
- 연락처: [kimrindev@gmail.com]
- 포트폴리오: 


}

---

이 프로젝트는 개인 포트폴리오 목적으로 개발되었으며, 실제 상업적 서비스가 아닙니다. TMDB API를 사용하여 영화 데이터를 제공합니다.
