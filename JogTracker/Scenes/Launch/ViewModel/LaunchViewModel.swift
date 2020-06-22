//
//  LaunchViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class LaunchViewModel: BaseViewModel {
    
    weak var auth: AuthServiceProtocol?
    
    override func setup() {
        super.setup()
    }
    
    init(auth: AuthServiceProtocol?) {
        self.auth = auth
    }
    
    override func createObservers() {
        
    }
}
