//
//  RootNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

enum RootNavigationState {
    case toLogin, toLogout, toJogs
}

class RootNavigationCoordinator: BaseNavigationCoordinator {
    
    override func next(_ command: Any?) {
        guard let navState = command as? RootNavigationState else {
            print("Couldn't resolve \(command ?? "undefined command")")
            return
        }
        
        switch navState {
        case .toLogin:
            self.showFlow(LoginViewController.self)
        case .toLogout:
            if let presented = rootViewController.presentedViewController {
                presented.dismiss(animated: true)
            }
        case .toJogs:
            self.showFlow(JogsViewController.self)
        }
    }
    
    override func movingBack() {
        rootViewController.dismiss(animated: true)
    }
}
