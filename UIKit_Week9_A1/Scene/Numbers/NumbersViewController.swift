//
//  NumbersViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NumbersViewController: BaseViewController {
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()

    private let result = UILabel()
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        [number1, number2, number3].forEach({
            $0.layer.borderWidth = 1
            $0.textAlignment = .right
            $0.keyboardType = .numberPad
            $0.layer.borderColor = UIColor.black.cgColor
        })
        result.textColor = .black
        result.textAlignment = .right
    }
    
    override func configureHierarchy() {
        [number1, number2, number3, result].forEach({ self.view.addSubview($0) })
    }
    
    override func configureLayout() {
        number1.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(100)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(100)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(100)
        }
        
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(100)
        }
    }
}
