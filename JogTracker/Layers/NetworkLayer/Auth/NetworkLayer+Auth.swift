//
//  NetworkLayer+Auth.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

extension NetworkLayer: AuthNetworkProtocol {
    func signIn(by uuid: String) -> Single<UserCredentials> {
        return sendRequest(provider: authProvider, target: AuthEndPoints.login(uuid: uuid))
    }
}
