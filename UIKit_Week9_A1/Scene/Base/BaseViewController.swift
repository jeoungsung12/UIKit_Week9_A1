//
//  BaseViewController.swift
//  UIKit_Week9_A1
//
//  Created by 정성윤 on 2/18/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
        setBindView()
        setBinding()
    }
    
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func setBindView() { }
    func setBinding() { }
}

