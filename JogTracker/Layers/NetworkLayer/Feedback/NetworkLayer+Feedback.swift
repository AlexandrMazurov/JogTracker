//
//  NetworkLayer+Feedback.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

extension NetworkLayer: FeedbackNetworkProtocol {

    func sendFeedback(topicId: Int, text: String) -> Single<FeedbackResponse> {
        return sendRequest(provider: feedbackProvider, target: FeedbackEndPoints.sendFeedback(topicId: topicId, text: text, token: preferences?.userToken ?? ""))
    }
}
