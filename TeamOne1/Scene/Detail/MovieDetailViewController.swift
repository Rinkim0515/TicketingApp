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
    movieDetailView.TicketingBtn.addTarget(self, action: #selector(changeView), for: .touchDown)
    
    
    
    
  }
  
  private func configureUI() {
    view.addSubview(movieDetailView)
    
    movieDetailView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  private func loadData(){
    guard let movie = movie else {return}
    
    let url = "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=4e7d627f53b0470f38e13533b907923c&language=ko-KR"
    MovieNetwork().getData(endPoint: url) {[weak self] (result: MovieDetailModel?) in
      guard let result,let self else { return }
      
      DispatchQueue.main.async {
        self.movieDetailView.nameLabel.text = result.title
        self.movieDetailView.releaseData.text = {
          var temp = "\(result.releaseDate)"
          var chars = Array(temp)
          chars[4] = "년"
          chars[7] = "월"
          chars.append("일")
          temp = String(chars)
          return temp
        }()
        
        
       
        self.movieDetailView.movieDescription.text = result.overview
        self.movieDetailView.ratingData.text =
        String(format: "%.1f", result.voteAverage) + "점 / 10점"
        


          
          self.posterPath = result.posterPath
        

        guard let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(result.posterPath)") else { return }
        self.movieDetailView.imgLabel.kf.setImage(with: imageUrl)
        
        
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
