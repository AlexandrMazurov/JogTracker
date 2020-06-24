//
//  FeedbackNetworkProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

protocol FeedbackNetworkProtocol {
    func sendFeedback(topicId: Int, text: String) -> Single<FeedbackResponse>
}

