//
//  LoginNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

class LoginNavigationCoordinator: BaseNavigationCoordinator {

    override func next(_ command: Any?) {}
    
    override func movingBack() {
        rootViewController.dismiss(animated: true)
    }
}
