//
//  JogInfoViewController.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import RxKeyboard

private enum Constants {
    static let invalidCredentialsMessage = "Invalid credentials"
    static let invalidCredentialsTitle = "Validation issue"
}

class JogInfoViewController: BaseViewController {
    
    @IBOutlet private weak var distanceTextField: UITextField!
    @IBOutlet private weak var timeTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    
    
    private var jogInfoViewModel: JogInfoViewModel? {
        return viewModel as? JogInfoViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = jogInfoViewModel,
            let coordinator = coordinator else {
            return
        }
        
        viewModel.actionButtonName
            .bind(onNext: { [weak self] name in
                self?.actionButton.setTitle(name, for: .normal)
            }).disposed(by: rxBag)
        
        viewModel.acceptStartValues.filterNil()
            .subscribe({ [weak self] jog in
                self?.distanceTextField.text = jog.element?.distance.description
                self?.timeTextField.text = jog.element?.time.description
                self?.datePicker.setDate(jog.element?.date ?? Date(), animated: true)
            }).disposed(by: rxBag)
        
        viewModel.isDataValid.asDriver().filterNil().drive(onNext: { [weak self] isValid in
            if !isValid {
                self?.showMessage(Constants.invalidCredentialsMessage, Constants.invalidCredentialsTitle)
            }
            }).disposed(by: rxBag)
        
        viewModel.completionActionState
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess ?? false {
                    self?.coordinator?.movingBack()
                }
            }).disposed(by: rxBag)
        
        distanceTextField.rx.text
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(viewModel.distance)
            .disposed(by: rxBag)
        
        timeTextField.rx.text
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(viewModel.time)
            .disposed(by: rxBag)
        
        datePicker.rx.date
            .asDriver(onErrorJustReturn: Date())
            .drive(viewModel.date)
            .disposed(by: rxBag)
        
        cancelButton.rx.tap
            .bind(onNext: coordinator.movingBack)
            .disposed(by: rxBag)
        
        actionButton.rx.tap
            .bind(onNext: viewModel.completeActions)
            .disposed(by: rxBag)
        
    }
    
}
