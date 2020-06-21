//
//  BaseViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift

public class BaseViewController: UIViewController {
 
    private(set) var rxBag = DisposeBag()
    private(set) var viewModel: BaseViewModel?
    private(set) weak var coordinator: NavigationCoordinatorProtocol?
    
    lazy var activityView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubviewWithAnchorsToSuperView(indicator)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    func configure(baseVM: BaseViewModel?, coordinator: NavigationCoordinatorProtocol) {
        self.viewModel = baseVM
        self.coordinator = coordinator
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setup()
        createObservers()
    }
    
    internal func createObservers() {
        guard let viewModel = viewModel else {
            fatalError("\(#function) viewModel was not initialized")
        }
        
        viewModel.inProgress
        .observeOn(MainScheduler.instance)
        .map { [weak self] result -> Bool in
            switch result {
            case .success, .none:
                return false
            case .error(let error):
                self?.showError(error, "JogTracker")
                return false
            case .started:
                return true
            }
        }
        .observeOn(MainScheduler.instance)
        .bind(to: activityView.rx.isAnimating)
        .disposed(by: rxBag)
        
        let driver = viewModel.inProgress
            .asDriver(onErrorJustReturn: .error("Handled error"))

        driver.map { _ in false }
            .asObservable()
            .bind(to: activityView.rx.isHidden)
            .disposed(by: rxBag)
    }
}

extension BaseViewController: Allerts {}
