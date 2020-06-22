//
//  AuthNetworkProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

protocol AuthNetworkProtocol {
    var authProvider: MoyaProvider<AuthEndPoints> { get }
    var authError: PublishSubject<NetworkError> { get }
    func signIn(by uuid: String) -> Single<LoginResponse>
}

