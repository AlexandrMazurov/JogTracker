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
    let fromFilterDate = BehaviorRelay<Date?>(value: nil)
    let toFilterDate = BehaviorRelay<Date?>(value: nil)
    private var unfilteredStatistic: [WeekStatistic]?
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
    
    func applyFilter() {
        guard let unfilteredStatistic = unfilteredStatistic else {
            return
        }
        var filteredStatistic = unfilteredStatistic
        if let fromDate = fromFilterDate.value {
            filteredStatistic = filteredStatistic.filter { $0.startWeekDate > fromDate }
        }
        if let toDate = toFilterDate.value {
            filteredStatistic = filteredStatistic.filter { $0.endWeekDate < toDate }
        }
        weakStatisticData.accept(filteredStatistic)
    }
    
    func resetFilter() {
        fromFilterDate.accept(nil)
        toFilterDate.accept(nil)
        setupWeekStatistic()
    }
    
    private func setupWeekStatistic() {
        guard let statisticManager = statisticManager,
            let jogs = jogs else {
            return
        }
        let statistic = statisticManager.calculateStatistic(from: jogs)
        unfilteredStatistic = statistic
        weakStatisticData.accept(statistic)
    }
}
