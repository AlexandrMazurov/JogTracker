//
//  StatisticViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class StatisticViewController: BaseViewController {
    
    @IBOutlet private weak var statisticTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPreferences()
    }
    
    private var loginViewModel: StatisticViewModel? {
        return viewModel as? StatisticViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
        
        statisticTableView.rx
            .setDelegate(self)
            .disposed(by: rxBag)
        
        statisticTableView.register(UINib(nibName: StatisticCell.reuseIdentifier, bundle: Bundle.main),
                                    forCellReuseIdentifier: StatisticCell.reuseIdentifier)
        
        viewModel.weakStatisticData
            .bind(to: statisticTableView
                .rx
                .items(cellIdentifier: StatisticCell.reuseIdentifier,
                       cellType: StatisticCell.self)) { row, weakStatistic, cell in
                        cell.configure(with: weakStatistic)
            }
        .disposed(by: rxBag)
    }
    
    private func setupViewPreferences() {
        statisticTableView.rowHeight = 100
    }
}

extension StatisticViewController: UITableViewDelegate {}
