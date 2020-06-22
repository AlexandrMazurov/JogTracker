//
//  AuthServiceProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AuthServiceProtocol {

    func signIn(by uuid: String) -> Single<Bool>
    func signOut()
}
