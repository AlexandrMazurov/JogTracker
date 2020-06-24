//
//  MenuCell.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuNameLabel: UILabel!
    
    func configure(with menu: MenuViewData) {
        self.menuImageView.image = UIImage(named: menu.imageName)
        self.menuNameLabel.text = menu.name
    }

}
