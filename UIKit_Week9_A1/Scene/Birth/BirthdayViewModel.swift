//
//  BirthdayViewModel.swift
//  UIKit_Week9_A1
//
//  Created by 정성윤 on 2/18/25.
//

import Foundation
import RxSwift
import RxCocoa

enum DateToString {
    case year(Int?)
    case month(Int?)
    case day(Int?)
    
    var dateString: String {
        switch self {
        case .year(let year):
            String(year ?? 0) + "년"
        case .month(let month):
            String(month ?? 0) + "월"
        case .day(let date):
            String(date ?? 0) + "일"
        }
    }
}

final class BirthdayViewModel: BaseViewModel {
    private var disposeBag = DisposeBag()
    private(set) var infoLabel = "만 17세 이상만 가입 가능합니다."
    struct Input {
        let validateTrigger: PublishSubject<DateComponents>
    }
    
    struct Output {
        let validateResult: PublishSubject<Bool> = PublishSubject()
    }
    
}

extension BirthdayViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.validateTrigger
            .bind(with: self) { owner, date in
                output.validateResult.onNext(owner.validateDate(date))
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func validateDate(_ date: DateComponents) -> Bool {
        let startDate = Calendar.current.date(from: date)!
        let offsetComps = Calendar.current.dateComponents([.year], from: startDate, to: Date())
        return (offsetComps.year ?? 0 >= 17) ? true : false
    }
}
