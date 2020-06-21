//
//  DependencyRegistry.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit
import Swinject

protocol DependencyRegistryProtocol: class {
    var container: Container { get }
}

class DependencyRegistry: DependencyRegistryProtocol {
    
    var container: Container
    
    init(container: Container) {
        self.container = container
        registerDependencies()
        registerViewModels()
        registerViewControllers()
    }
    
    private func registerDependencies() {
        container.register(RootNavigationCoordinator.self) { (_, rootViewController: UIViewController) in
            return RootNavigationCoordinator(with: rootViewController, registry: self)
        }
        
        container.register(JogsNavigationCoordinator.self) { (_, rootViewController: UIViewController) in
            return JogsNavigationCoordinator(with: rootViewController, registry: self)
        }
        
        container.register(LoginNavigationCoordinator.self) { (_, rootViewController: UIViewController) in
            return LoginNavigationCoordinator(with: rootViewController, registry: self)
        }
    }
    
    private func registerViewModels() {
        
    }
    
    private func registerViewControllers() {
        
    }
}
