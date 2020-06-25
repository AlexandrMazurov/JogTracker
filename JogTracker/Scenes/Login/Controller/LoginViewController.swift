//
//  LoginViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import RxViewController
import RxKeyboard
import RxGesture
import RxOptional

private enum Constants {
    static let invalidUUIDMessage = "Invalid UUID"
    static let invalidUUIDTitle = "Validation issue"
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    private var loginViewModel: LoginViewModel? {
        return viewModel as? LoginViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
        
        viewModel.auth?.isAuthenticated.asDriver().filterNil()
            .drive(onNext: { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.coordinator?.movingBack()
                }
            }).disposed(by: rxBag)
        
        viewModel.uuidValidationStatus.asDriver().filterNil()
            .drive (onNext: { [weak self] isFailureValidation in
                self?.showMessage(Constants.invalidUUIDMessage, Constants.invalidUUIDTitle)
            }).disposed(by: rxBag)
        
        uuidTextField.rx.text
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(viewModel.uuid)
            .disposed(by: rxBag)
        
        loginButton.rx.tap
            .bind(onNext: viewModel.doLogin)
            .disposed(by: rxBag)
        
        firstResponderPosition()
        endEditing()

    }
    
    private func firstResponderPosition() {
        observingOfViewPosition(RxKeyboard.instance.visibleHeight
            .map({ [uuidTextField, weak self] keyboardHeight -> CGFloat? in
                return self?.moveUp(keyboardHeight, textField: uuidTextField)
            })
            .asDriver()
        )
    }
    
    private func endEditing() {
        observingEndEditing(
            view.rx.tapGesture().asDriver()
        )
        observingEndEditing(
            view.rx.swipeGesture([.down]).asDriver()
        )
    }
    
    private func observingOfViewPosition(_ driver: Driver<CGFloat?>) {
        driver
            .filterNil()
            .drive(onNext: {[weak self] (bottom) in
                self?.view.frame.origin.y = -bottom
            })
            .disposed(by: rxBag)
    }
    
    private func observingEndEditing<T>(_ driver: Driver<T>) where T: UIGestureRecognizer {
        driver
            .drive(onNext: {[weak self] (_) in
                self?.view.endEditing(true)
            })
            .disposed(by: rxBag)
    }
    
    private func moveUp(_ keyboardHeight: CGFloat, textField: UITextField? ) -> CGFloat? {
        if keyboardHeight == .zero { return .zero }
         guard let textField = textField, textField.isFirstResponder
         else {
             return nil
         }
        let distance = view.frame.height - textField.convert(textField.frame.origin, to: view).y - textField.frame.height
         let delta = keyboardHeight + distance
        return delta > .zero ? delta: .zero
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
