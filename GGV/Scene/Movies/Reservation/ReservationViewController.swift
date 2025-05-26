//
//  BookingViewController.swift
//  TeamOne1
//
//  Created by 김동준 on 7/25/24.


import UIKit
import SnapKit
import UIKit

final class ReservationViewController: UIViewController {
    var parentVC: MovieDetailViewController?
    var numberCount: Int = Constants.Movie.minimumPeople
    var price: Int = Constants.Movie.ticketPrice
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
    let peopleLabel: UILabel = UIComponents.Label.body("상영 인원: ", size: 25, weight: .bold)
    let peopleCountLabel: UILabel = UIComponents.Label.center("1", size: 25)
    lazy var decreaseButton: UIButton = UIComponents.Button.icon(title: " - ", backgroundColor: .lightBlue, fontSize: 25)
    lazy var increaseButton: UIButton = UIComponents.Button.icon(title: " + ", backgroundColor: .lightPink, fontSize: 25)
    let priceLabel: UILabel = UIComponents.Label.center("14000원", size: 25)
    lazy var payButton: UIButton = UIComponents.Button.system(title: "결제하기", backgroundColor: .red)
    
    // pickerView 안에 들어갈 날짜 더미데이터
    var dateGenerator: [String] {
        var result: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                result.append(formatter.string(from: date))
            }
        }
        return result
    }
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
            
            self.price -= Constants.Movie.ticketPrice
            priceLabel.text = "\(price)원"
        }
    }
    
    @objc
    private func plusButtonTapped() {
        self.numberCount += 1
        peopleCountLabel.text = "\(numberCount)"
        
        self.price += Constants.Movie.ticketPrice
        priceLabel.text = "\(price)원"
        
    }
    
    // 경고메세지 출력
    @objc private func pressPayButton() {
        guard let saveDate = saveDate, let movieTitle = movieTitle, let saveTime = saveTime else {
            let alert = UIAlertController(title: "오류", message: "예약 정보가 완전하지 않습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
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
                price: self.numberCount * Constants.Movie.ticketPrice,
                movieTitle: self.movieTitle ?? "",
                movieId: self.movieId,
                posterPath: self.posterPath ?? ""
            )
            
            // 저장된 모든 예약 내역 출력
            if let allReservations = DataController.loadReservationsFromUserDefaults(key: "allReservations") {
                print("####", allReservations)
            }
            
            self.dismiss(animated: true, completion: { [weak self]  in
                self?.parentVC?.navigationController?.popViewController(animated: true)
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
            return dateGenerator.count
        case 2:
            return time.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return dateGenerator[row]
        case 2:
            return time[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            saveDate = dateGenerator[row]
        } else if pickerView.tag == 2 {
            saveTime = time[row]
        }
    }
}

