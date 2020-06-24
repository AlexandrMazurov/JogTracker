//
//  FeedbackProvider.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedbackProvider: FeedbackProviderProtocol {
    
    private let network: FeedbackNetworkProtocol?
    
    init(network: FeedbackNetworkProtocol?) {
        self.network = network
    }
    
    func sendFeedback(topicId: Int, text: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Feedback API was not injected"))
                return Disposables.create()
            }
            let disposable = network.sendFeedback(topicId: topicId, text: text)
                .subscribe(onSuccess: { data in
                    single(SingleEvent.success(true))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
    
    
}
