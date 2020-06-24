//
//  JogCell.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

private enum Constants {
    static let fromDiagonalToRadiusDevider: CGFloat = 2
    static let distanceMetric = "km"
    static let timeMetric = "min"
    static let speedMetric = "km/h"
}

class JogCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var distanceValueLabel: UILabel!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var speedValueLabel: UILabel!
    @IBOutlet private weak var dateValueLabel: UILabel!
    @IBOutlet private weak var cellImageView: UIImageView!
    
    func configure(with jog: Jog, cellImage: UIImage?) {
        distanceValueLabel.text = "\(Int(jog.distance)) \(Constants.distanceMetric)"
        timeValueLabel.text = "\(Int(jog.time)) \(Constants.timeMetric)"
        speedValueLabel.text = "\(Int(jog.speed.isNaN ? 0: jog.speed)) \(Constants.speedMetric)"
        dateValueLabel.text = dateStringFormat(from: jog.date)
        self.cellImageView.image = cellImage
        cellImageView.layer.cornerRadius = cellImageView.frame.width / Constants.fromDiagonalToRadiusDevider
    }
    
    private func dateStringFormat(from date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
}
