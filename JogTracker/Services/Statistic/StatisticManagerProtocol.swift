//
//  StatisticManagerProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/25/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

protocol StatisticManagerProtocol {
    func calculateStatistic(from jogs: [Jog]) -> [WeakStatistic]
}
