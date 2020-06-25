//
//  JogsNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

enum JogsNavigationState {
    case toStatistic, toFeedback, toJogDetails(_ details: Jog?), toAddJog
}

class JogsNavigationCoordinator: BaseNavigationCoordinator {
    
    override func next(_ command: Any?) {
        guard let navState = command as? JogsNavigationState else {
            print("Couldn't resolve \(command ?? "undefined command")")
            return
        }
        switch navState {
        case .toStatistic:
            self.push(StatisticViewController.self)
        case .toFeedback:
            self.push(FeedbackViewController.self)
        case .toJogDetails(let jog):
            self.showFlow(JogInfoViewController.self, presentationStype: .overCurrentContext, argument: JogInfoAction.edit(jog: jog))
        case .toAddJog:
            self.showFlow(JogInfoViewController.self, presentationStype: .overCurrentContext, argument: JogInfoAction.addJog)
        }
    }
    
    override func movingBack() {
        rootViewController.dismiss(animated: true)
    }
}
