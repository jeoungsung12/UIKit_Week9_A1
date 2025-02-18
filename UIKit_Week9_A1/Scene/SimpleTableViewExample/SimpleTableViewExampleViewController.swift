//
//  SimpleTableViewExampleViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleViewController: BaseViewController {
    private var tableView = UITableView()
    let items = Observable.just(
        (0..<20).map { "\($0)" }
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
                let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
                imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
                cell.accessoryView = imageView
            }
            .disposed(by: disposeBag)

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                self.showAlert()
            }
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .bind(with: self, onNext: { owner, indexPath in
                self.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}


extension SimpleTableViewExampleViewController {
    private func showAlert() {
        let alert = UIAlertController(
            title: "성공",
            message: "완벽해요!",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
