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
    
    weak var auth: AuthServiceProtocol?
    
    init(auth: AuthServiceProtocol?) {
        self.auth = auth
    }
    
    override func setup() {
        super.setup()
    }
    
    override func createObservers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.auth?.signOut()
        }
    }
}
