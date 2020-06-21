//
//  StatisticViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class StatisticViewController: BaseViewController {
    
    private var loginViewModel: StatisticViewModel? {
        return viewModel as? StatisticViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
    }
}
