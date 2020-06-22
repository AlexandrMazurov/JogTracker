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
    
    func present(_ root: BaseViewController) {
        childCoordinator = root.coordinator
        let controller: UIViewController = root.navigationController ?? root
        controller.modalPresentationStyle = .fullScreen
        rootViewController.present(controller, animated: true)
    }

    func push<T>(_ type: T.Type, argument: Any? = nil) where T: BaseViewController {

        let controller = argument != nil ?
            registry.container.resolve(type.self, argument: argument) :
            registry.container.resolve(type.self)
        guard let baseController = controller
        else {
            print("Couldn't resolve \(type) ")
            return
        }

        guard let navController = rootViewController as? UINavigationController
        else {
            print("Couldn't resolve root controller as UINaviationController")
            return
        }
        DispatchQueue.main.async {
            navController.pushViewController(baseController, animated: true)
        }
    }
}
    
extension BaseNavigationCoordinator {
    func showFlow<T>(_ type: T.Type, argument: Any? = nil) where T: BaseViewController {

        let controller = argument != nil ?
            registry.container.resolve(type.self, argument: argument) :
            registry.container.resolve(type.self)
        guard let baseController = controller
        else {
            print("Couldn't resolve \(type) ")
            return
        }
        DispatchQueue.main.async {
            self.present(baseController)
        }
    }
}
