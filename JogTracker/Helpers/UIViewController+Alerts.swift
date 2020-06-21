//
//  UIViewController+Alerts.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

typealias ExecuteAction = (UIAlertAction) -> Void

protocol Allerts {
    func showError(_ error: Error, _ title: String?, _ actions: [(String, ExecuteAction?)]? )
    func showMessage(_ message: String?, _ title: String?, _ actions: [(String, ExecuteAction?)]?,
                     dismissTime: TimeInterval?, _ completion: (() -> Void)?)
}

extension Allerts where Self: UIViewController {

    func showError(_ error: Error, _ title: String?, _ actions: [(String, ExecuteAction?)]? = [("Ok", nil)]) {
        let alert = UIAlertController(title: title,
                                      message: error.message(),
                                      preferredStyle: .alert)
        actions?.forEach { action in
            alert.addAction(UIAlertAction(title: action.0, style: .default, handler: action.1))
        }
        self.present(alert, animated: true, completion: nil)
    }

    func showMessage(_ message: String?, _ title: String?, _ actions: [(String, ExecuteAction?)]? = [("Ok", nil)],
                     dismissTime: TimeInterval? = nil, _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        actions?.forEach { action in
            alert.addAction(UIAlertAction(title: action.0, style: .default, handler: action.1))
        }
        self.present(alert, animated: true, completion: nil)
        dismissAfter(alert, dismissTime, completion)
    }

    private func dismissAfter(_ alert: UIAlertController?, _ interval: TimeInterval?, _ completion: (() -> Void)? = nil) {
        guard let interval = interval
        else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak alert, completion] in
            alert?.dismiss(animated: true)
            completion?()
        }
    }
}
