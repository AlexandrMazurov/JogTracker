//
//  FeedbackViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedbackViewModel: BaseViewModel {
    
    let topics = BehaviorRelay<[Int]>(value: [1,2,3,5,8])
    let selectedTopic = BehaviorRelay<Int>(value: 1)
    let message = BehaviorRelay<String>(value: "")
    
    let completionActionState = BehaviorRelay<Bool?>(value: nil)
    
    private weak var feedbackProvider: FeedbackProviderProtocol?
    
    init(feedbackProvider: FeedbackProviderProtocol?) {
        self.feedbackProvider = feedbackProvider
    }
    
    override func setup() {
        super.setup()
    }
    
    override func createObservers() {
        
    }
    
    func sendFeedback() {
        self.inProgress.onNext(.started)
        feedbackProvider?.sendFeedback(topicId: selectedTopic.value, text: message.value)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.inProgress.onNext(.success(isSuccess))
                self?.completionActionState.accept(isSuccess)
                }, onError: { [weak self] error in
                    self?.inProgress.onNext(.error(error))
            }).disposed(by: rxBag)
    }
}
