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
    private let viewModel: MovieDetailVM
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - lifeCyvle
    init(movie: Movie) {
        self.viewModel = MovieDetailVM(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
        movieDetailView.TicketingButton.addTarget(self, action: #selector(changeView), for: .touchDown)
    }
    
    private func configureUI() {
        view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.fetchDetail()
            
        }
        
        viewModel.$movie
            .receive(on: RunLoop.main)
            .sink { [weak self] movie in
                self?.render(movie: movie)
            }
            .store(in: &cancellables)
        
        viewModel.$isNowPlaying
            .receive(on: RunLoop.main)
            .sink { [weak self] isNowPlaying in
                self?.validReserve(status: isNowPlaying)
            }
            .store(in: &cancellables)
    }
    
    
    private func render(movie: Movie) {
        let dateFormatted = formatDate(movie.releaseDate ?? "")
        movieDetailView.movieNameLabel.text = movie.title
        movieDetailView.releaseData.text = dateFormatted
        movieDetailView.movieDescription.text = (movie.overview?.isEmpty != nil) ? "줄거리 정보가 없습니다." : movie.overview
        movieDetailView.ratingScore.text = movie.voteAverage != nil ? String(format: "%.1f", movie.voteAverage! ) + "점 / 10점" : "평점 없음"
        validReserve(status: viewModel.isNowPlaying)
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")") {
            movieDetailView.posterView.kf.setImage(with: url)
        }
    }
    
    private func validReserve(status: Bool) {
        if !status {
            movieDetailView.TicketingButton.isEnabled = false
            movieDetailView.TicketingButton.backgroundColor = .systemGray
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
    
    
    
    // 하프모달 메서드
    func showModal(viewController: UIViewController) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }
    
    @objc func changeView(){
        //        guard let movie else { return }
        //        let reservationVC = ReservationViewController()
        //        reservationVC.movieTitle = movie.title
        //        reservationVC.movieId = movie.id
        //        reservationVC.posterPath = posterPath
        //        reservationVC.sss = self
        //        showModal(viewController: reservationVC)
        
        
    }
}
