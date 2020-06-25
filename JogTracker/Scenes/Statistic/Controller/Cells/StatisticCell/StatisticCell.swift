//
//  StatisticCell.swift
//  JogTracker
//
//  Created by Александр on 6/25/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

class StatisticCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var weekLebel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    func configure(with statistic: WeekStatistic) {
        weekLebel.text = "Week \(statistic.weekNumber): (\(dateStringFormat(from: statistic.startWeekDate) ?? "") / \(dateStringFormat(from: statistic.endWeekDate) ?? ""))"
        speedLabel.text = "Av. Speed: \(Int(statistic.averageSpeed)) km/h"
        timeLabel.text = "Av. Time: \(Int(statistic.avarageTime)) min"
        distanceLabel.text = "Total Distance: \(Int(statistic.distance)) km"
    }
    
    private func dateStringFormat(from date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }

}

