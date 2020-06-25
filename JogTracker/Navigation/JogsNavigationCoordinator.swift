//
//  JogsNavigationCoordinator.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum JogsNavigationState {
    case toStatistic(_ jogs: [Jog]), toFeedback, toJogDetails(_ details: Jog?), toAddJog
}

class JogsNavigationCoordinator: BaseNavigationCoordinator {
    
    let movingBackCompleted = BehaviorRelay<Bool?>(value: nil)
    
    override func next(_ command: Any?) {
        guard let navState = command as? JogsNavigationState else {
            print("Couldn't resolve \(command ?? "undefined command")")
            return
        }
        switch navState {
        case .toStatistic(let jogs):
            self.push(StatisticViewController.self, argument: jogs)
        case .toFeedback:
            self.showFlow(FeedbackViewController.self, presentationStype: .overCurrentContext)
        case .toJogDetails(let jog):
            self.showFlow(JogInfoViewController.self, presentationStype: .overCurrentContext, argument: JogInfoAction.edit(jog: jog))
        case .toAddJog:
            self.showFlow(JogInfoViewController.self, presentationStype: .overCurrentContext, argument: JogInfoAction.addJog)
        }
    }
    
    override func movingBack() {
        rootViewController.dismiss(animated: true)
        movingBackCompleted.accept(true)
    }
}
