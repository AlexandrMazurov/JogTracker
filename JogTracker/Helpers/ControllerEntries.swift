//
//  ControllerEntries.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case login = "LoginViewController"
    case feedback = "FeedbackViewController"
    case statistic = "StatisticViewController"
    case jogs = "JogsViewController"
    case launch = "LaunchViewController"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                             function: String = #function,
                                             line: Int = #line,
                                             file: String = #file) -> T {
        let storyboardID = viewControllerClass.storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("""
                ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.
                File: \(file)
                Line Number: \(line)
                Function: \(function)
                """)
        }
        return scene
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiate(from storyboard: Storyboard) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
}
