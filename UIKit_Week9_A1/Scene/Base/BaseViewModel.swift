//
//  BaseViewModel.swift
//  UIKit_Week9_A1
//
//  Created by 정성윤 on 2/18/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
