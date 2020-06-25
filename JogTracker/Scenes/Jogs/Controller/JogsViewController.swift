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
    static let openMenuDuration: Double = 0.3
    static let runLogoName = "runLogo"
    static let menuIconName = "menuIcon"
}

class JogsViewController: BaseViewController {
    
    
    @IBOutlet private weak var jogsTableView: UITableView!
    @IBOutlet private weak var menuTableView: UITableView!
    @IBOutlet private weak var menuLeftCanstraint: NSLayoutConstraint!
    @IBOutlet private weak var menuView: UIView!
    
    let isMenuOpen = BehaviorRelay<Bool>(value: false)
    
    private var loginViewModel: JogsViewModel? {
        return viewModel as? JogsViewModel
    }
    
    override func viewDidLoad() {
        setupViewPreferences()
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
        
        jogsTableView.rx
            .itemSelected
            .subscribe { [weak self] indexPath in
                self?.coordinator?.next(JogsNavigationState.toJogDetails(viewModel.jog(for: indexPath.element)))
        }.disposed(by: rxBag)
        
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
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(onNext: { [weak self] in
                self?.isMenuOpen.accept(!(self?.isMenuOpen.value ?? false))
            })
            .disposed(by: rxBag)
        
        isMenuOpen.subscribe { [weak self] isOpen in
            self?.setMenu(isOpen: isOpen.element ?? false, animated: true)
        }.disposed(by: rxBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: { [weak self] in
                self?.coordinator?.next(JogsNavigationState.toAddJog)
            }).disposed(by: rxBag)
    }
    
    private func setupViewPreferences() {
        configureNavigationBar()
        self.jogsTableView.rowHeight = Constants.jogCellHeight
        self.menuTableView.rowHeight = Constants.menuCellHeight
    }
    
    private func setMenu(isOpen: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? Constants.openMenuDuration: .zero) {
            self.menuLeftCanstraint.constant = isOpen ? .zero: -self.menuView.frame.width
            self.menuView.superview?.layoutIfNeeded()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.menuIconName),
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .yellow
        navigationItem.rightBarButtonItem?.tintColor = .yellow
    }
}

extension JogsViewController: UITableViewDelegate {}
