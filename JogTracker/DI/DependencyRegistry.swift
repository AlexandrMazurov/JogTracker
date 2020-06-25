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
        
        container.register(NetworkLayer.self) {
            NetworkLayer(preferences: $0.resolve(AppPreferences.self))
        }.inObjectScope(.container)
        
        container.register(AuthServiceProtocol.self) {
            AuthenticationService(authApi: $0.resolve(NetworkLayer.self),
                                  preferences: $0.resolve(AppPreferences.self))
        }.inObjectScope(.container)
        
        container.register(JogsProviderProtocol.self) {
            JogsProvider(network: $0.resolve(NetworkLayer.self))
        }.inObjectScope(.container)
        
        container.register(FeedbackProviderProtocol.self) {
            FeedbackProvider(network: $0.resolve(NetworkLayer.self))
        }.inObjectScope(.container)
        
        container.register(StatisticManagerProtocol.self) { _ in
            StatisticManager()
        }
    }
    
    private func registerViewModels() {
        container.register(LaunchViewModel.self) {
            LaunchViewModel(auth: $0.resolve(AuthServiceProtocol.self))
        }
        
        container.register(LoginViewModel.self) {
            LoginViewModel(auth: $0.resolve(AuthServiceProtocol.self))
        }
        
        container.register(FeedbackViewModel.self) {
            FeedbackViewModel(feedbackProvider: $0.resolve(FeedbackProviderProtocol.self))
        }
        
        container.register(StatisticViewModel.self) { (res, arg: Any?) in
            guard let jogs = arg as? [Jog] else {
                return StatisticViewModel(jogs: nil, statisticManager: res.resolve(StatisticManagerProtocol.self))
            }
            return StatisticViewModel(jogs: jogs, statisticManager: res.resolve(StatisticManagerProtocol.self))
        }
        
        container.register(JogsViewModel.self) {
            JogsViewModel(jogsProvider: $0.resolve(JogsProviderProtocol.self))
        }
        
        container.register(JogInfoViewModel.self) { (res, arg: Any?) in
            guard let action = arg as? JogInfoAction else {
                return JogInfoViewModel(action: nil, jogProvider: res.resolve(JogsProviderProtocol.self))
            }
            return JogInfoViewModel(action: action, jogProvider: res.resolve(JogsProviderProtocol.self))
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
        
        container.register(StatisticViewController.self) { (res, arg: Any?) in
            let controller = StatisticViewController.instantiate(from: .statistic)
            controller.configure(baseVM: res.resolve(StatisticViewModel.self, argument: arg), coordinator: self.navigationCoordinator)
            return controller
        }
        
        container.register(JogsViewController.self) { _ in
            JogsViewController.instantiate(from: .jogs)
        }
        
        container.register(JogInfoViewController.self) { (res, arg: Any?) in
            let controller = JogInfoViewController.instantiate(from: .info)
            controller.configure(baseVM: res.resolve(JogInfoViewModel.self, argument: arg), coordinator: self.navigationCoordinator)
            return controller
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
