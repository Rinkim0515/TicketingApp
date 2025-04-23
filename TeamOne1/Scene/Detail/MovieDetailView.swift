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
  
   lazy var imgLabel = {
    let lb = UIImageView()
    lb.backgroundColor = .gray
    return lb
  }()
   lazy var nameLabel = {
    let lb = UILabel()
    lb.text = "영화이름"
     lb.numberOfLines = 2
    lb.textAlignment = .center
    lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 30)
    return lb
  }()
  lazy var movieDescription = {
  let lb = UILabel()
  lb.text = "영화 설명란"
    lb.numberOfLines = 30
    lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 19)
  lb.textColor = .black
  return lb
}()
  
  let ratingView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .fillEqually
    return sv
  }()
  let ratingLabel = {
    let lb = UILabel()
    lb.text = "평점:"
    lb.textAlignment = .left
    lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
    return lb
  }()
  lazy var ratingData = {
  let lb = UILabel()
  lb.text = "별점: 7.8/10 점"
  lb.textAlignment = .right
  lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
  return lb
}()
  
  private let releaseView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .fillProportionally
    return sv
  }()
  
  let releaseLabel = {
    let lb = UILabel()
    lb.text = "출시일:"
    lb.textAlignment = .left
    lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
    return lb
  }()
  
  
   lazy var releaseData = {
    let lb = UILabel()
    lb.text = "2021-07-07"
    lb.textAlignment = .right
    lb.font = UIFont(name: "NanumSquareNeo-cBd", size: 22)
    return lb
  }()
  
   let TicketingBtn = {
    let btn = UIButton()
    btn.setTitle("예매하기", for: .normal)
    btn.setTitleColor(.white, for: .normal)
    btn.titleLabel?.font = UIFont(name: "NanumSquareNeo-cBd", size: 30)
    btn.backgroundColor = .red
    return btn
  }()
  
  

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    fixDescriptionSpacing()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func fixDescriptionSpacing(){
    let attrString = NSMutableAttributedString(string: movieDescription.text!)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
    movieDescription.attributedText = attrString
  }
  
  private func configureUI(){
    
    self.backgroundColor = .white
    self.addSubview(TicketingBtn)
    
    self.addSubview(scrollView)
    scrollView.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview().offset(-70)

    }
    
    scrollView.addSubview(scrollContentView)
    
    scrollContentView.snp.makeConstraints{
      $0.edges.equalTo(scrollView)
      $0.width.equalTo(scrollView)
      $0.height.equalTo(1150)
    }
    
    [
      imgLabel,
      nameLabel,
      movieDescription,
      ratingView,
      releaseView,
      movieDescription,
      
    ].forEach{scrollContentView.addSubview($0)}
    
    [
      ratingLabel,
      ratingData
    ].forEach{ratingView.addArrangedSubview($0)}
    
    
    [
      releaseLabel,
      releaseData
    ].forEach{releaseView.addArrangedSubview($0)}

    
    
    
    imgLabel.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalTo(scrollContentView)
      
      $0.height.equalTo(550)
      $0.top.equalTo(scrollContentView).offset(30)
      $0.width.equalTo(380)
    }
    nameLabel.snp.makeConstraints{
      $0.top.equalTo(imgLabel.snp.bottom).offset(10)
      $0.leading.equalTo(imgLabel.snp.leading)
      $0.width.equalTo(imgLabel)
      $0.height.equalTo(80)
    }
    movieDescription.snp.makeConstraints{
      
      $0.top.equalTo(nameLabel.snp.bottom).offset(10)
      $0.leading.equalTo(imgLabel.snp.leading).inset(10)
      $0.trailing.equalTo(imgLabel.snp.trailing).offset(-10)
      $0.height.equalTo(300)
      
    }
    ratingView.snp.makeConstraints{
      $0.width.equalTo(imgLabel).inset(20)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(movieDescription.snp.bottom).offset(20)
    }
    
    releaseView.snp.makeConstraints{
      $0.width.equalTo(imgLabel).inset(20)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(ratingView.snp.bottom).offset(20)
    }
    
    
    TicketingBtn.snp.makeConstraints{
      $0.bottom.equalTo(self)
      $0.width.equalTo(self)
      $0.height.equalTo(70)
      $0.centerX.equalToSuperview()
    }

    
  }
}
