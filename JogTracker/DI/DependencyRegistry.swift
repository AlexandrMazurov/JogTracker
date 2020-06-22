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
    var navigationCoordinator: NavigationCoordinatorProtocol! { get }
    
    func makeRootNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol
    func makeLoginNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol
    func makeJogsNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol
}

class DependencyRegistry: DependencyRegistryProtocol {
    
    var container: Container
    var navigationCoordinator: NavigationCoordinatorProtocol!
    
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
        
        container.register(AppPreferences.self) { _ in
            AppPreferences()
        }.inObjectScope(.container)
        
        container.register(NetworkLayer.self) {_ in
            NetworkLayer()
        }.inObjectScope(.container)
        
        container.register(AuthServiceProtocol.self) {
            AuthenticationService(authApi: $0.resolve(NetworkLayer.self),
                                  preferences: $0.resolve(AppPreferences.self))
        }.inObjectScope(.container)
    }
    
    private func registerViewModels() {
        container.register(LaunchViewModel.self) { _ in
            LaunchViewModel()
        }
        
        container.register(LoginViewModel.self) { _ in
            LoginViewModel()
        }
        
        container.register(FeedbackViewModel.self) { _ in
            FeedbackViewModel()
        }
        
        container.register(StatisticViewModel.self) { _ in
            StatisticViewModel()
        }
        
        container.register(JogsViewModel.self) { _ in
            JogsViewModel()
        }
    }
    
    private func registerViewControllers() {
        container.register(LaunchViewController.self) { _ in
            LaunchViewController.instantiate(from: .launch)
        }
        
        container.register(LoginViewController.self) { _ in
            LoginViewController.instantiate(from: .login)
        }
        
        container.register(FeedbackViewController.self) { _ in
            FeedbackViewController.instantiate(from: .feedback)
        }
        
        container.register(StatisticViewController.self) { _ in
            StatisticViewController.instantiate(from: .statistic)
        }
        
        container.register(JogsViewController.self) { _ in
            JogsViewController.instantiate(from: .jogs)
        }
    }
    
    func makeRootNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol {
        navigationCoordinator = container.resolve(RootNavigationCoordinator.self, argument: rootViewController)
        return navigationCoordinator
    }
    
    func makeLoginNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol {
        navigationCoordinator = container.resolve(LoginNavigationCoordinator.self, argument: rootViewController)
        return navigationCoordinator
    }
    
    func makeJogsNavigationCoordinator(rootViewController: UIViewController) -> NavigationCoordinatorProtocol {
        navigationCoordinator = container.resolve(JogsNavigationCoordinator.self, argument: rootViewController)
        return navigationCoordinator
    }
}
