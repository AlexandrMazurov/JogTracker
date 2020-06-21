//
//  LaunchViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class LaunchViewController: BaseViewController {
    
    private var loginViewModel: LaunchViewModel? {
        return viewModel as? LaunchViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
    }
}
