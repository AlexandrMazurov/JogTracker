//
//  View-Layout.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

public typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                _ toKeyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: toKeyPath], constant: constant)
    }
}

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

public extension UIView { //Layout
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    func addSubviewWithAnchorsToSuperView(_ child: UIView) {
        self.addSubview(child, constraints: [equal(\.topAnchor),
                                             equal(\.bottomAnchor),
                                             equal(\.leftAnchor),
                                             equal(\.rightAnchor)])
    }
}
