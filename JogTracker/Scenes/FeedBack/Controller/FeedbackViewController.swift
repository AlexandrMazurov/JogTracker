//
//  FeedbackViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedbackViewController: BaseViewController {
    
    private var loginViewModel: FeedbackViewModel? {
        return viewModel as? FeedbackViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
    }
}
