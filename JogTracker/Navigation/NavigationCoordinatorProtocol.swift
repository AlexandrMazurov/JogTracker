//
//  NavigationCoordinatorProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

protocol NavigationCoordinatorProtocol: class {
    func next(_ command: Any?)
    func movingBack()
}
