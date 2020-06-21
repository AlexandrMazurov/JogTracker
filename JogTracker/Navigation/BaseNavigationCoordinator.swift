//
//  BaseNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

class BaseNavigationCoordinator: NavigationCoordinatorProtocol {
    
    private(set) weak var registry: DependencyRegistryProtocol!
    private(set) var rootViewController: UIViewController!
    private(set) weak var childCoordinator: NavigationCoordinatorProtocol?
    
    init(with rootViewController: UIViewController, registry: DependencyRegistry) {
        self.registry = registry
        self.rootViewController = rootViewController
    }

    func next(_ command: Any?) {}
    func movingBack() {}
    
}
    

