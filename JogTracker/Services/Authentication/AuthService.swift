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
    
    private(set) var isAuthenticated = BehaviorRelay<Bool?>(value: nil)
    
    private let network: AuthNetworkProtocol?
    private weak var preferences: AppPreferences?
    private let rxBag = DisposeBag()
    
    init(authApi: AuthNetworkProtocol?, preferences: AppPreferences?) {
        self.network = authApi
        self.preferences = preferences
        isAuthenticated.accept(preferences?.isUserMakeLogin)
    }
    
    func signIn(by uuid: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Authentication network was not injected"))
                return Disposables.create()
            }
            
            let disposable = network.signIn(by: uuid)
                .subscribe(onSuccess: { loginResponse in
                    self?.preferences?.userToken = loginResponse.response.accessToken
                    self?.isAuthenticated.accept(true)
                    single(SingleEvent.success(true))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
    
    func signOut() {
        preferences?.userToken = nil
        isAuthenticated.accept(false)
    }
    
    
}
