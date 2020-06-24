//
//  LoginViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel {
    
    let uuid = BehaviorRelay<String>(value: "")
    let uuidValidationStatus = BehaviorRelay<Bool?>(value: nil)
    
    weak var auth: AuthServiceProtocol?
    
    init(auth: AuthServiceProtocol?) {
        self.auth = auth
    }
    
    override func setup() {
        super.setup()
    }
    
    override func createObservers() {

    }
    
    func doLogin() {
        guard isUUIDValid() else {
            uuidValidationStatus.accept(false)
            return
        }
        self.inProgress.onNext(.started)
        auth?.signIn(by: uuid.value)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.inProgress.onNext(.success(true))
            }, onError: { [weak self] error in
                self?.inProgress.onNext(.error(error))
            }).disposed(by: rxBag)
    }
    
    private func isUUIDValid() -> Bool {
        return !uuid.value.isEmpty
    }
}
