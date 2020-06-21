//
//  JogsNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

enum JogsNavigationState {
    case toStatistic, toFeedback
}

class JogsNavigationCoordinator: BaseNavigationCoordinator {
    
    override func next(_ command: Any?) {
        guard let navState = command as? JogsNavigationState else {
            print("Couldn't resolve \(command ?? "undefined command")")
            return
        }
        switch navState {
        case .toStatistic:
            print("toStatistic")
        case .toFeedback:
            print("toFeedback")
        }
        //TODO: implement navigation
    }
}
