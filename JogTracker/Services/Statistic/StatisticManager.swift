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

    func calculateStatistic(from jogs: [Jog]) -> [WeakStatistic] {
        var weekStartAndEndDates = Set<DateInterval>()
        jogs.forEach {
            weekStartAndEndDates
                .insert(DateInterval(startDate: $0.date.startOfWeek ?? Date(), endDate: $0.date.endOfWeek ?? Date()))
        }
        let filteredWeeks = Array(weekStartAndEndDates).sorted { $0.startDate < $1.startDate }
        let weakStatistic: [WeakStatistic] = filteredWeeks.enumerated().compactMap { (index, inteval) in
            let jogs = jogs.filter { inteval.startDate < $0.date && $0.date < inteval.endDate }
            return WeakStatistic(weakNumber: index + 1,
                                 startWeakDate: inteval.startDate,
                                 endWeekDate: inteval.endDate,
                                 averageSpeed: (jogs.map { $0.speed }.reduce(.zero, +) / Float(jogs.count)),
                                 avarageTime: (jogs.map { $0.time }.reduce(.zero, +) / Float(jogs.count)),
                                 distance: jogs.map { $0.distance }.reduce(.zero, +))
        }.filter{ $0.averageSpeed != .nan }.sorted { $0.startWeakDate < $1.startWeakDate }
        return weakStatistic
    }
    
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
