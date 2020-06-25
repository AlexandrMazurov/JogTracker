//
//  StatisticViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class StatisticViewModel: BaseViewModel {
    
    let weakStatisticData = BehaviorRelay<[WeekStatistic]>(value: [])
    private let jogs: [Jog]?
    
    private var statisticManager: StatisticManagerProtocol?
    
    
    init(jogs: [Jog]?, statisticManager: StatisticManagerProtocol?) {
        self.jogs = jogs
        self.statisticManager = statisticManager
    }
    
    override func setup() {
        super.setup()
        setupWeekStatistic()
    }
    
    override func createObservers() {
    }
    
    private func setupWeekStatistic() {
        guard let statisticManager = statisticManager,
            let jogs = jogs else {
            return
        }
        weakStatisticData.accept(statisticManager.calculateStatistic(from: jogs))
    }
}
