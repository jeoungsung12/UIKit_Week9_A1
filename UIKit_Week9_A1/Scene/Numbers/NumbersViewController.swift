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
        
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
}
