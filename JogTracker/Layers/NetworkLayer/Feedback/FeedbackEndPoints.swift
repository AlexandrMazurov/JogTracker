//
//  FeedbackEndPoints.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation
import Moya

enum FeedbackEndPoints {
    case sendFeedback(topicId: Int, text: String, token: String)
}

extension FeedbackEndPoints: TargetType {

    var baseURL: URL {
        return AppConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .sendFeedback:
            return "/feedback/send"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendFeedback:
            return .post
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .sendFeedback(let topicId, let text, let token):
            return .requestParameters(parameters: ["access_token": token, "topic_id": topicId, "text": text], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendFeedback:
            switch self {
            case .sendFeedback:
                return ["Content-Type": "application/json"]
            }
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
