//
//  SimpleValidationViewModel.swift
//  UIKit_Week9_A1
//
//  Created by 정성윤 on 2/18/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleValidationViewModel: BaseViewModel {
    private(set) var minimalUsernameLength = 5
    private(set) var minimalPasswordLength = 5
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
}

extension SimpleValidationViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        
        return output
    }
    
}
