//
//  FeedbackViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import RxViewController
import RxGesture
import RxOptional

private enum Constants {
    static let succesSendFeedbackTitle = "Success"
    static let succesSendFeedbackMessage = "Feedback sent successfully!"
}

class FeedbackViewController: BaseViewController {
    
    @IBOutlet weak var messageLabel: UITextField!
    @IBOutlet weak var topicPickerView: UIPickerView!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var loginViewModel: FeedbackViewModel? {
        return viewModel as? FeedbackViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel,
            let coordinator = coordinator else {
            return
        }
        
        viewModel.topics
            .bind(to: topicPickerView.rx.itemTitles) { row, element in
                return element.description
            }.disposed(by: rxBag)
        
        viewModel.completionActionState
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess ?? false {
                    if isSuccess ?? false {
                        self?.showMessage(Constants.succesSendFeedbackMessage, Constants.succesSendFeedbackTitle)
                    }
                }
            }).disposed(by: rxBag)
        
        topicPickerView.rx.itemSelected
            .subscribe { event in
                switch event {
                case .next(let row, _):
                    viewModel.selectedTopic.accept(viewModel.topics.value[row])
                default:
                    break
                }
        }.disposed(by: rxBag)
        
        messageLabel.rx.text
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(viewModel.message)
            .disposed(by: rxBag)
        
        cancelButton.rx.tap
            .bind(onNext: coordinator.movingBack)
            .disposed(by: rxBag)
        
        sendFeedbackButton.rx.tap
            .bind(onNext: viewModel.sendFeedback)
            .disposed(by: rxBag)
        
        endEditing()
    }
    
    private func endEditing() {
        observingEndEditing(
            view.rx.tapGesture().asDriver()
        )
        observingEndEditing(
            view.rx.swipeGesture([.down]).asDriver()
        )
    }
    
    private func observingEndEditing<T>(_ driver: Driver<T>) where T: UIGestureRecognizer {
        driver
            .drive(onNext: {[weak self] (_) in
                self?.view.endEditing(true)
            })
            .disposed(by: rxBag)
    }
}

extension FeedbackViewController: UIPickerViewDelegate {}
