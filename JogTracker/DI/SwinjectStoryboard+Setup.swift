//
//  SwinjectStoryboard+Setup.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc
    class func setup() {
        if SceneDelegate.dependencyRegistry == nil {
            SceneDelegate.dependencyRegistry = DependencyRegistry(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistryProtocol = SceneDelegate.dependencyRegistry
        
        func main() {
            
            dependencyRegistry.container.storyboardInitCompleted(LaunchViewController.self) { (reg, controller) in
                let coordinator = dependencyRegistry.makeRootNavigationCoordinator(rootViewController: controller)
                setupData(navigationCoordinator: coordinator)
                controller.configure(baseVM: reg.resolve(LaunchViewModel.self), coordinator: coordinator)
            }
            
            dependencyRegistry.container.storyboardInitCompleted(LoginViewController.self) { (reg, controller) in
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                let coordinator = dependencyRegistry.makeLoginNavigationCoordinator(rootViewController: navigationController)
                controller.configure(baseVM: reg.resolve(LoginViewModel.self), coordinator: coordinator)
            }
            
            dependencyRegistry.container.storyboardInitCompleted(JogsViewController.self) { (reg, controller) in
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                let coordinator = dependencyRegistry.makeJogsNavigationCoordinator(rootViewController: navigationController)
                controller.configure(baseVM: reg.resolve(JogsViewModel.self), coordinator: coordinator)
            }
            
            dependencyRegistry.container.storyboardInitCompleted(FeedbackViewController.self) { (reg, controller) in
                let coordinator = dependencyRegistry.makeJogsNavigationCoordinator(rootViewController: controller)
                controller.configure(baseVM: reg.resolve(FeedbackViewModel.self), coordinator: coordinator)
            }
            
            dependencyRegistry.container.storyboardInitCompleted(StatisticViewController.self) { _, _ in }
            
            dependencyRegistry.container.storyboardInitCompleted(JogInfoViewController.self) { _, _ in } 

        }
        
        func setupData(navigationCoordinator: NavigationCoordinatorProtocol) {
            SceneDelegate.rootCoordinator = navigationCoordinator
        }
        
        main()
    }
}
