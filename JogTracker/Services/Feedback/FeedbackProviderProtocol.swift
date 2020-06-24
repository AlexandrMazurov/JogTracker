//
//  FeedbackProviderProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FeedbackProviderProtocol: class {
    func sendFeedback(topicId: Int, text: String) -> Single<Bool>
}
