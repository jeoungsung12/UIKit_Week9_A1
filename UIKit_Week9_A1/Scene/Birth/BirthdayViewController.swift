//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum Color {
    static let black: UIColor = .textPoint
    static let white: UIColor = .viewPoint
}

final class BirthdayViewController: BaseViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    private let viewModel = BirthdayViewModel()
    private let inputTrigger = BirthdayViewModel.Input(validateTrigger: PublishSubject())
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBindView() {
        nextButton.rx.tap
            .debug()
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        birthDayPicker.rx.date.changed
            .map { date in
                let calender = Calendar.current
                let year = calender.component(.year, from: date)
                let month = calender.component(.month, from: date)
                let day = calender.component(.day, from: date)
                return DateComponents(year: year, month: month, day: day)
            }
            .bind(with: self) { owner, date in
                owner.inputTrigger.validateTrigger.onNext(date)
                owner.yearLabel.text = DateToString.year(date.year).dateString
                owner.monthLabel.text = DateToString.month(date.month).dateString
                owner.dayLabel.text = DateToString.day(date.day).dateString
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.validateResult
            .bind(with: self) { owner, valid in
                owner.nextButton.isEnabled = valid
                owner.infoLabel.text = valid ? nil : owner.viewModel.infoLabel
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = Color.white
    }
    
    override func configureHierarchy() {
        [infoLabel, containerStackView, birthDayPicker, nextButton].forEach({ self.view.addSubview( $0 )})
    }
    
    override func configureLayout() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
