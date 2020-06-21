//
//  LoginNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

enum LoginNavigationState {
    case toJogs
}

class LoginNavigationCoordinator: BaseNavigationCoordinator {

    override func next(_ command: Any?) {
        guard let navState = command as? LoginNavigationState else {
            print("Couldn't resolve \(command ?? "undefined command")")
            return
        }
        
        switch navState {
        case .toJogs:
            print("toJogs")
        }
        //TODO: implement navigation
    }
    
    override func movingBack() {
        rootViewController.dismiss(animated: true)
    }
}
