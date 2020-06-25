//
//  StatisticManager.swift
//  JogTracker
//
//  Created by Александр on 6/25/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

class DateInterval: Hashable {
    var startDate: Date
    var endDate: Date
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( startDate.hashValue )
    }
    
    public static func == (lhs: DateInterval, rhs: DateInterval) -> Bool {
        return lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate
    }
}

class StatisticManager: StatisticManagerProtocol {

    func calculateStatistic(from jogs: [Jog]) -> [WeekStatistic] {
        var weekStartAndEndDates = Set<DateInterval>()
        jogs.forEach {
            weekStartAndEndDates
                .insert(DateInterval(startDate: $0.date.startOfWeek ?? Date(), endDate: $0.date.endOfWeek ?? Date()))
        }
        let filteredWeeks = Array(weekStartAndEndDates).sorted { $0.startDate < $1.startDate }
        let weekStatistic: [WeekStatistic] = filteredWeeks.enumerated().compactMap { (index, inteval) in
            let jogs = jogs.filter { inteval.startDate < $0.date && $0.date < inteval.endDate }
            return WeekStatistic(weekNumber: index + 1,
                                 startWeekDate: inteval.startDate,
                                 endWeekDate: inteval.endDate,
                                 averageSpeed: (jogs.map { $0.speed }.reduce(.zero, +) / Float(jogs.count)),
                                 avarageTime: (jogs.map { $0.time }.reduce(.zero, +) / Float(jogs.count)),
                                 distance: jogs.map { $0.distance }.reduce(.zero, +))
        }.filter{ $0.averageSpeed > 0 }.sorted { $0.startWeekDate < $1.startWeekDate }
        return weekStatistic
    }
    
}
