//
//  MovieDetailViewController.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
// 장르, 상영시간
//

import UIKit
import SnapKit
import Kingfisher
import Combine

final class MovieDetailViewController: UIViewController{
    private let movieDetailView = MovieDetailView()
    private let viewModel: MovieDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var isNowPlaying: Bool = false
    
    init(movieId: Int, isNowPlaying: Bool) {
        self.viewModel = MovieDetailViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        self.isNowPlaying = isNowPlaying
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    deinit {
        print("👍 \(String(describing: type(of: self))) deinit")
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setupUI() {
        self.title = "영화 상세 설명"
        view.addSubview(movieDetailView)
        movieDetailView.TicketingButton.addAction(UIAction(handler: { [weak self] _ in
            self?.changeView()
        }), for: .touchDown)
        
        movieDetailView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.fetchDetail()
        }
        bindViewModel()
    }
    private func bindViewModel() {
        viewModel.$movie
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] movie in
                self?.configure(with: movie)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func configure(with movie: Movie) {
        let dateFormatted = formatDate(movie.releaseDate ?? "")
        movieDetailView.movieNameLabel.text = movie.title
        movieDetailView.releaseData.text = dateFormatted
        movieDetailView.movieDescription.text = movie.overview == nil ? "줄거리 정보가 없습니다." : movie.overview
        if let voteAverage = movie.voteAverage {
            movieDetailView.ratingScore.text = String(format: "%.1f", voteAverage) + "점 / 10점"
        } else {
            movieDetailView.ratingScore.text = "평점 없음"
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")") {
            movieDetailView.posterView.kf.setImage(with: url)
        } else {
            movieDetailView.posterView.image = UIImage(named: "image_nil")
        }
        validReserve(status: isNowPlaying)
    }

    private func validReserve(status: Bool) {
        if status == false {
            movieDetailView.TicketingButton.isEnabled = false
            movieDetailView.TicketingButton.backgroundColor = .systemGray
        } else {
            movieDetailView.TicketingButton.isEnabled = true
            movieDetailView.TicketingButton.backgroundColor = .systemRed
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: date)
        }
        return dateString
    }
    
    func showModal(viewController: UIViewController) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }
    
    private func changeView(){
        guard let movie = viewModel.movie else { return }
        let reservationVC = ReservationViewController()
        reservationVC.movieTitle = movie.title
        reservationVC.movieId = movie.id
        reservationVC.posterPath = movie.posterPath
        reservationVC.parentVC = self
        showModal(viewController: reservationVC)
    }
    
}
