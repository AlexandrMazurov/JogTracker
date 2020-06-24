//
//  JogsViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

private enum Constants {
    static let jogCellHeight: CGFloat = 130
}

class JogsViewController: BaseViewController {
    
    
    @IBOutlet weak var jogsTableView: UITableView!
    
    private var loginViewModel: JogsViewModel? {
        return viewModel as? JogsViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
        
        jogsTableView.rx
            .setDelegate(self)
            .disposed(by: rxBag)
        
        jogsTableView
            .register(UINib(nibName: JogCell.reuseIdentifier, bundle: Bundle.main),
                      forCellReuseIdentifier: JogCell.reuseIdentifier)
        
        viewModel.jogsViewData
            .bind(to: jogsTableView
                .rx
                .items(cellIdentifier: JogCell.reuseIdentifier,
                       cellType: JogCell.self)) { row, jog, cell in
                        cell.configure(with: jog, cellImage: UIImage(named: "runLogo") ?? UIImage())
            }
        .disposed(by: rxBag)
        
        self.rx
            .viewWillAppear
            .map { _ in Void() }
            .bind(onNext: viewModel.loadJogs)
            .disposed(by: rxBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
}

extension JogsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.jogCellHeight
    }
}
