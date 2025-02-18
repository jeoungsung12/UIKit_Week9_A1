//
//  SimpleValidationViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: BaseViewController {
    private let titleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let usernameValidLabel = UILabel()
    
    private let subTitleLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordValidLabel = UILabel()
    private let doSomethingButton = UIButton()
    
    private let viewModel = SimpleValidationViewModel()
    private let input = SimpleValidationViewModel.Input()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map { $0.count >= self.viewModel.minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.viewModel.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)

    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        titleLabel.text = "이름"
        subTitleLabel.text = "비밀번호"
        usernameValidLabel.text = "이름은 적어도 \(viewModel.minimalUsernameLength)글자 이상 되어야합니다."
        passwordValidLabel.text = "비밀번호는 적어도 \(viewModel.minimalPasswordLength)글자 이상 되어야합니다."
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        
        [titleLabel, subTitleLabel].forEach({ $0.textAlignment = .left })
        
        doSomethingButton.backgroundColor = .green
        doSomethingButton.setTitle("Do Something", for: .normal)
        doSomethingButton.setTitleColor(.black, for: .normal)
    }
    
    override func configureHierarchy() {
        [titleLabel, usernameTextField, usernameValidLabel, subTitleLabel, passwordTextField, passwordValidLabel, doSomethingButton].forEach({ self.view.addSubview($0) })
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        usernameValidLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(usernameTextField.snp.bottom).offset(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(usernameValidLabel.snp.bottom).offset(12)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
        }
        
        passwordValidLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
        }
        
        doSomethingButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(passwordValidLabel.snp.bottom).offset(12)
        }
        
    }
}

extension SimpleValidationViewController {
    
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
