//
//  BookingViewController.swift
//  TeamOne1
//
//  Created by 김동준 on 7/25/24.
// 좋아요 기능의 추가
// 예매한 영화리스트 추가
// 마이페이지 밑에 테이블 뷰로 차라리 구현하는게 나을듯 함. 

import UIKit
import SnapKit

final class ReservationViewController: UIViewController {
  var sss: MovieDetailViewController?
    var numberCount: Int = 1
    var price: Int = 14000
    var saveDate: String? = "2024.07.29"
    var saveTime: String? = "오전 10시 35분"
    var movieTitle: String?
    var movieId: Int = 0
    var posterPath: String?
    
    // 날짜
    let setDate: UIPickerView = {
        let pkv = UIPickerView()
        pkv.tag = 1
        return pkv
    }()
    // 영화 상영시간
    let setTime: UIPickerView = {
        let pkv = UIPickerView()
        pkv.tag = 2
        return pkv
    }()
    
    // 영화 인원수 라벨
    let peopleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "상영 인원: "
        lb.textColor = .black
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 25)
        return lb
    }()
    
    // 티켓 구매자 인원
    let peopleCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.backgroundColor = .white
        return label
    }()
    
    // 마이너스 버튼
    lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle(" - ", for: .normal)
      button.backgroundColor = UIColor(hexCode: "99b8ff", alpha: 1.0)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchDown)
        return button
    }()
    
    // 플러스 버튼
    lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle(" + ", for: .normal)
        button.backgroundColor = UIColor(hexCode: "ff99a3", alpha: 1.0)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchDown)
        return button
    }()
    
    // 영화 가격
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "14000원"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.backgroundColor = .white
        return label
    }()
    
    // 결제하기 버튼
    lazy var payButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.setTitle("결제하기", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont(name: "NanumSquareNeo-dEb", size: 27)
      button.backgroundColor = .red
        button.frame.size = CGSize.init(width: 150, height: 60)
      
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pressPayButton), for: .touchUpInside)
        return button
    }()
    
    // pickerView 안에 들어갈 날짜 더미데이터
    var 날짜 = ["2024.07.29", "2024.07.30", "2024.07.31", "2024.08.01", "2024.08.02"]
    // 영화 시간 버튼 설정
    var time = ["오전 10시 35분", "오후 1시 50분", "오후 3시 10분", "오후 5시 30분", "오후 9시 10분"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setDate.delegate = self
        setDate.dataSource = self
        setDate.backgroundColor = .white
        
        setTime.delegate = self
        setTime.dataSource = self
        setTime.backgroundColor = .white
        
    }
    
    func setupUI() {
        [setDate, setTime, peopleLabel, increaseButton, peopleCountLabel, decreaseButton, priceLabel, payButton].forEach { view.addSubview($0) }
        
        setDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(200)
        }
        
        setTime.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(setDate.snp.trailing).inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(200)
        }
        
        peopleLabel.snp.makeConstraints {
            $0.top.equalTo(setDate.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        increaseButton.snp.makeConstraints {
            $0.top.equalTo(setDate.snp.bottom).offset(30)
            $0.leading.equalTo(peopleCountLabel.snp.trailing).offset(10)
            $0.height.equalTo(25)
        }
        
        peopleCountLabel.snp.makeConstraints {
            $0.top.equalTo(setDate.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(70)
            $0.width.equalTo(60)
            $0.height.equalTo(25)
        }
        
        decreaseButton.snp.makeConstraints {
            $0.top.equalTo(setDate.snp.bottom).offset(30)
            $0.trailing.equalTo(peopleCountLabel.snp.leading).offset(-10)
            $0.height.equalTo(25)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(peopleCountLabel.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        payButton.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
          $0.height.equalTo(40)
          $0.width.equalTo(300)
        }
        

    }
    
    @objc
    private func minusButtonTapped() {
        if self.numberCount > 1 {
            self.numberCount -= 1
            peopleCountLabel.text = "\(numberCount)"
            
            self.price -= 14000
            priceLabel.text = "\(price)원"
        }
    }
    
    @objc
        private func plusButtonTapped() {
            self.numberCount += 1
            peopleCountLabel.text = "\(numberCount)"
            
            self.price += 14000
            priceLabel.text = "\(price)원"
            
    }
    
    // 경고메세지 출력
    @objc private func pressPayButton() {
      guard let saveDate = saveDate, let movieTitle = movieTitle, let saveTime = saveTime else { return }

      let confirmAlert = UIAlertController(title: "결제 확인", message: "제목: \(movieTitle)\n 상영 시간: \(saveDate) \(saveTime) \n 인원 수: \(numberCount) 금액 :\(price) \n 결제하시겠습니까", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "결제", style: .default, handler: { _ in
            self.showPaymentCompletedAlert()
        }))
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    // 결제완료 메세지 출력
    private func showPaymentCompletedAlert() {

        let completedAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다.", preferredStyle: .alert)

        completedAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            // 예약 정보 저장
            DataController.saveReservationToUserDefaults(
                date: self.saveDate ?? "",
                time: self.saveTime ?? "",
                people: self.numberCount,
                price: self.numberCount * 14000,
                movieTitle: self.movieTitle ?? "",
                movieId: self.movieId,
                posterPath: self.posterPath ?? ""
            )

            // 저장된 모든 예약 내역 출력
            if let allReservations = DataController.loadReservationsFromUserDefaults(key: "allReservations") {
                print("####", allReservations)
            }
            
            self.dismiss(animated: true, completion: {
                self.sss?.navigationController?.popViewController(animated: true)
            })
        }))
        self.present(completedAlert, animated: true, completion: nil)

    }
}
    
    extension ReservationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch pickerView.tag {
            case 1:
                return 날짜.count
            case 2:
                return time.count
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            switch pickerView.tag {
            case 1:
                return 날짜[row]
            case 2:
                return time[row]
            default:
                return nil
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView.tag == 1 {
                saveDate = 날짜[row]
            } else if pickerView.tag == 2 {
                saveTime = time[row]
            }
        }
    }
           
