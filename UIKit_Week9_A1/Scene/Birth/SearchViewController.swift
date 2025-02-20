//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let tableView: UITableView = {
       let view = UITableView()
//        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    private var disposeBag = DisposeBag()
    
    let items = Observable.just([
        "First Item",
        "Second Item",
        "Third Item"
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func test() {
        let mentor = Observable.of("Hue", "Jack", "Bran", "Den")
        let age = Observable.of(10, 11, 12, 13)
        
        Observable.zip(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        print(#function)
        
        searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("리턴키 클릭")
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 글자")
            }
            .disposed(by: disposeBag)

//        items
//        .bind(to: tableView.rx.items) { (tableView, row, element) in
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
//            cell.appNameLabel.text = "\(element) @ row \(row)"
//            return cell
//        }
//        .disposed(by: disposeBag)
        //2개 이상의 옵저버블을 하나로 합쳐줌
        //zip vs combineLatest
        Observable.combineLatest(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map {
                return "\($0.0)\($0.1)"
            }
            .bind(with: self) { owner, value in
                print(value) //index + data
//                print(value.1) //data
            }.disposed(by: disposeBag)
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
