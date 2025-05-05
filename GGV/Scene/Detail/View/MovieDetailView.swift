//
//  MovieDetailView.swift
//  TeamOne1
//
//  Created by bloom on 7/22/24.
//

import Foundation
import UIKit
import SnapKit


final class MovieDetailView: UIView {
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    let posterView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        return view
    }()
    let movieNameLabel = {
        let label = UILabel()
        label.text = "영화이름"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 30)
        return label
    }()
    let movieDescription = {
        let label = UILabel()
        label.text = "영화 설명란"
        label.numberOfLines = 30
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 19)
        label.textColor = .black
        return label
    }()
    private let ratingStackView = {
        let uIStackView = UIStackView()
        uIStackView.axis = .horizontal
        uIStackView.distribution = .fillEqually
        return uIStackView
    }()
    let ratingLabel = {
        let label = UILabel()
        label.text = "평점:"
        label.textAlignment = .left
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
        return label
    }()
    let ratingScore = {
        let label = UILabel()
        label.text = "별점: 7.8/10 점"
        label.textAlignment = .right
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
        return label
    }()
    private let releaseStackView = {
        let uIStackView = UIStackView()
        uIStackView.axis = .horizontal
        uIStackView.distribution = .fillProportionally
        return uIStackView
    }()
    let releaseLabel = {
        let label = UILabel()
        label.text = "출시일:"
        label.textAlignment = .left
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
        return label
    }()
    let releaseData = {
        let label = UILabel()
        label.text = "2021-07-07"
        label.textAlignment = .right
        label.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
        return label
    }()
    let TicketingButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareNeo-cBd", size: 30)
        button.backgroundColor = .red
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        fixDescriptionSpacing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with data: MovieDetailModel) {
        movieNameLabel.text = data.title
        
        let dateFormatted = formatDate(data.releaseDate)
        releaseData.text = dateFormatted
        
        movieDescription.text = data.overview.isEmpty ? "줄거리 정보가 없습니다." : data.overview
        
        ratingScore.text = String(format: "%.1f", data.voteAverage) + "점 / 10점"
        
        fixDescriptionSpacing()
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
    
    
    // 영화 설명란 줄 간격 확장처리
    private func fixDescriptionSpacing(){
        let attrString = NSMutableAttributedString(string: movieDescription.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        movieDescription.attributedText = attrString
    }
    
    private func configureUI(){
        self.backgroundColor = .white
        self.addSubview(TicketingButton)
        
        self.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        [posterView,
         movieNameLabel,
         movieDescription,
         ratingStackView,
         releaseStackView,
         movieDescription].forEach{scrollContentView.addSubview($0)}
        [ratingLabel,
         ratingScore].forEach{ratingStackView.addArrangedSubview($0)}
        [releaseLabel,
         releaseData].forEach{releaseStackView.addArrangedSubview($0)}
        
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().offset(-70)
        }
        scrollContentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(1150)
        }
        posterView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(scrollContentView)
            $0.height.equalTo(550)
            $0.top.equalTo(scrollContentView).offset(30)
            $0.width.equalTo(380)
        }
        movieNameLabel.snp.makeConstraints{
            $0.top.equalTo(posterView.snp.bottom).offset(10)
            $0.leading.equalTo(posterView.snp.leading)
            $0.width.equalTo(posterView)
            $0.height.equalTo(80)
        }
        movieDescription.snp.makeConstraints{
            $0.top.equalTo(movieNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(posterView.snp.leading).inset(10)
            $0.trailing.equalTo(posterView.snp.trailing).offset(-10)
            $0.height.equalTo(300)
        }
        ratingStackView.snp.makeConstraints{
            $0.width.equalTo(posterView).inset(20)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(movieDescription.snp.bottom).offset(20)
        }
        releaseStackView.snp.makeConstraints{
            $0.width.equalTo(posterView).inset(20)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ratingStackView.snp.bottom).offset(20)
        }
        TicketingButton.snp.makeConstraints{
            $0.bottom.equalTo(self)
            $0.width.equalTo(self)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
        }
    }
}
