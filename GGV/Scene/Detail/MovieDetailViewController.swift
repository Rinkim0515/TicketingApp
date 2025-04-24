//
//  MovieDetailViewController.swift
//  TeamOne1
//
//  Created by bloom on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieDetailViewController: UIViewController{
  let movieDetailView = MovieDetailView()
  var movie: MovieListModel?
  weak var sss: ReservationViewController?
  
    var posterPath: String?

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
  
  private func loadData(){
    guard let movie = movie else {return}
      
      Task {
          let data = await MovieNetwork().getData(movieId: movie.id)
          await MainActor.run {
              guard let data else { return }
              self.movieDetailView.movieNameLabel.text = data.title
                
              self.movieDetailView.releaseData.text = {
                var temp = "\(data.releaseDate)"
                var chars = Array(temp)
                chars[4] = "년"
                chars[7] = "월"
                chars.append("일")
                temp = String(chars)
                return temp
              }()
              self.movieDetailView.movieDescription.text = data.overview == "" ? "줄거리 정보가 없습니다." : data.overview
              
              self.movieDetailView.ratingScore.text =
              String(format: "%.1f", data.voteAverage) + "점 / 10점"
                self.posterPath = data.posterPath
              guard let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)") else { return }
              self.movieDetailView.posterView.kf.setImage(with: imageUrl)
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
      guard let movie else { return }
      let reservationVC = ReservationViewController()
      reservationVC.movieTitle = movie.title
      reservationVC.movieId = movie.id
      reservationVC.posterPath = posterPath
      reservationVC.sss = self
      showModal(viewController: reservationVC)

    
  }
}
