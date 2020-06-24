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
    static let menuCellHeight: CGFloat = 50
    static let runLogoName = "runLogo"
    static let menuIconName = "menuIcon"
}

class JogsViewController: BaseViewController {
    
    
    @IBOutlet private weak var jogsTableView: UITableView!
    @IBOutlet private weak var menuTableView: UITableView!
    
    private var loginViewModel: JogsViewModel? {
        return viewModel as? JogsViewModel
    }
    
    override func viewDidLoad() {
        configureNavigationBar()
        self.jogsTableView.rowHeight = Constants.jogCellHeight
        self.menuTableView.rowHeight = Constants.menuCellHeight
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = .darkText
        self.navigationController?.navigationBar.barStyle = .black
                                
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
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
                        cell.configure(with: jog, cellImage: UIImage(named: Constants.runLogoName))
            }
        .disposed(by: rxBag)
        
        menuTableView.rx
            .setDelegate(self)
            .disposed(by: rxBag)
        
        menuTableView.register(UINib(nibName: MenuCell.reuseIdentifier, bundle: Bundle.main),
                               forCellReuseIdentifier: MenuCell.reuseIdentifier)
        
        viewModel.menuViewData
            .bind(to: menuTableView
                .rx
                .items(cellIdentifier: MenuCell.reuseIdentifier,
                       cellType: MenuCell.self)) { row, menu, cell in
                        cell.configure(with: menu)
            }
        .disposed(by: rxBag)
        
        
        
        self.rx
            .viewWillAppear
            .map { _ in Void() }
            .bind(onNext: viewModel.loadJogs)
            .disposed(by: rxBag)
        
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.menuIconName),
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .yellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .yellow
        navigationItem.rightBarButtonItem?.tintColor = .yellow
    }
}

extension JogsViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return Constants.jogCellHeight
//    }
}
