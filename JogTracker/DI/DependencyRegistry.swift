//
//  DependencyRegistry.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit
import Swinject

protocol DependencyRegistryProtocol {
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
        
    }
    
    private func registerViewModels() {
        
    }
    
    private func registerViewControllers() {
        
    }
}
