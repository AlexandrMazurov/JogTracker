//
//  NetworkLayer.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

enum NetworkError: LocalizedError {
    case unknown
    case invalidData
    case invalidAuthentication
    case notConnectedToInternet
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unexpected error happened"
        case .invalidData:
            return "JSON model could not be recognized"
        case .invalidAuthentication:
            return "Provided invalid credentials"
        case .notConnectedToInternet:
            return "No Internet connection"
        }
    }
}

class NetworkLayer {
    private(set) var authProvider: MoyaProvider<AuthEndPoints>
    private(set) var jogsProvider: MoyaProvider<JogsEndPoints>
    var authError = PublishSubject<NetworkError>()
    weak var preferences: AppPreferences?
    
    init(preferences: AppPreferences?) {
        self.preferences = preferences
        authProvider = MoyaProvider<AuthEndPoints>(plugins: [])
        jogsProvider = MoyaProvider<JogsEndPoints>(plugins: [])
    }
    
    func sendRequest<T: Decodable, U: TargetType>(provider: MoyaProvider<U>, target: U) -> Single<T> {
        return provider.rx
            .request(target)
            .map(T.self)
            .catchError { [weak self] error in
                guard let error = error as? MoyaError else {
                    throw NetworkError.unknown
                }
                switch error {
                case .jsonMapping, .objectMapping:
                    throw NetworkError.invalidData
                case .statusCode(_):
                    self?.authError.onNext(.invalidAuthentication)
                    throw NetworkError.invalidAuthentication
                case .underlying(let error, _):
                    self?.authError.onNext(.invalidAuthentication)
                    let code = (error as NSError).code
                    switch URLError.Code(rawValue: code) {
                    case .notConnectedToInternet:
                        throw NetworkError.notConnectedToInternet
                    default: break
                    }
                    throw NetworkError.unknown
                default:
                    throw NetworkError.invalidData
                }
        }
    }
}
