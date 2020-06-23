//
//  JogsEndPoints.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation
import Moya

enum JogsEndPoints {
    case jogs(token: String), createJog(jog: Jog, token: String), editJog(jog: Jog, token: String)
}

extension JogsEndPoints: TargetType {

    var baseURL: URL {
        return AppConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .jogs:
            return "/data/sync"
        case .createJog, .editJog:
            return "/data/jog"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .jogs:
            return .get
        case .createJog:
            return .post
        case .editJog:
            return .put
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .jogs(let token):
            return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.default)
        case .createJog(let jog, let token):

            return .requestParameters(parameters: ["access_token": token,
                                                   "date": jog.date.timeIntervalSinceReferenceDate.description,
                                                   "distance": jog.distance,
                                                   "time": jog.time],
                                      encoding: JSONEncoding.default)
        case .editJog(let jog, let token):
            return .requestParameters(parameters: ["access_token": token,
                                                   "date" : jog.date.timeIntervalSinceReferenceDate.description,
                                                   "distance": jog.distance,
                                                   "time": jog.time,
                                                   "jog_id": jog.id ?? "",
                                                   "user_id": jog.userId ?? ""],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .jogs, .createJog, .editJog:
            return ["Content-Type": "application/json"]
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
