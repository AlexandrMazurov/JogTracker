//
//  AuthService.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

public class AuthenticationService: AuthServiceProtocol {
    
    private let network: AuthNetworkProtocol?
    private weak var preferences: AppPreferences?
    private let rxBag = DisposeBag()
    
    init(authApi: AuthNetworkProtocol?, preferences: AppPreferences?) {
        self.network = authApi
        self.preferences = preferences
    }
    
    func signIn(by uuid: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Authentication network was not injected"))
                return Disposables.create()
            }
            
            let disposable = network.signIn(by: uuid)
                .subscribe(onSuccess: { userCredentials in
                    self?.preferences?.userToken = userCredentials.accessToken
                    single(SingleEvent.success(true))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
    
    func signOut() {
        preferences?.userToken = nil
    }
    
    
}
