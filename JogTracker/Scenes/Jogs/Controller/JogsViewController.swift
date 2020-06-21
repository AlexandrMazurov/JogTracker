//
//  JogsViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class JogsViewController: BaseViewController {
    
    private var loginViewModel: JogsViewModel? {
        return viewModel as? JogsViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
    }
}
