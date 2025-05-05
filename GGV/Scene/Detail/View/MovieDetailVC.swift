//
//  MovieDetailViewController.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

final class MovieDetailViewController: UIViewController{
    let movieDetailView = MovieDetailView()
    var movie: Movie?
    weak var sss: ReservationViewController?
    private let viewModel: MovieDetailVM
    
    var posterPath: String?
    
    init(viewModel: MovieDetailVM = MovieDetailVM()) {
        self.viewModel = viewModel
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
            guard let movie = movie else { return }
            await viewModel.fetchDetail(for: movie.id)

            guard let data = viewModel.movieDetail else { return }
            movieDetailView.configure(with: data)

            posterPath = data.posterPath

            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)") {
                movieDetailView.posterView.kf.setImage(with: url)
            }
        }
        
        
        
        
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
