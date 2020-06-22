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
    
    private var launchViewModel: LaunchViewModel? {
        return viewModel as? LaunchViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = launchViewModel else {
            return
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let isAuthenticated = launchViewModel?.isAuthenticated else {
            print("LaunchViewModel was not initialized")
            return
        }
        
        let navigation = isAuthenticated ? RootNavigationState.toJogs : RootNavigationState.toLogin
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.coordinator?.next(navigation)
        }
    }
}
