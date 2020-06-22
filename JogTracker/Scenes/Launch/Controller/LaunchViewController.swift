//
//  LaunchViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import RxViewController
import RxGesture

class LaunchViewController: BaseViewController {
    
    private var launchViewModel: LaunchViewModel? {
        return viewModel as? LaunchViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        rx.viewDidAppear
            .take(1)
            .map { _ in () }
            .bind(onNext: createObserving)
            .disposed(by: rxBag)
    }
    
    private func createObserving() {
        guard let auth = launchViewModel?.auth else {
            print("LaunchViewModel was not initialized")
            return
        }
        
        auth.isAuthenticated
            .distinctUntilChanged()
            .filter { !($0 ?? true) }
            .map { _ in RootNavigationState.toLogout }
            .observeOn(MainScheduler.instance)
            .subscribe { self.coordinator?.next($0.element) }
            .disposed(by: rxBag)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let isAuthenticated = launchViewModel?.auth?.isAuthenticated.value else {
            print("LaunchViewModel was not initialized")
            return
        }
        let navigation: RootNavigationState = isAuthenticated ? .toJogs : .toLogin
        self.coordinator?.next(navigation)
    }
}
