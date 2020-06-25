//
//  JogsViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

private enum Constants {
    static let statistikMenuName = "Statistic"
    static let feedbackMenuName = "Feedback"
    static let statisticMenuIconName = "statisticMenuIcon"
    static let feedbackMenuIconName = "feedbackMenuIcon"
    
}

class JogsViewModel: BaseViewModel {
    
    let jogsViewData = BehaviorRelay<[Jog]>(value: [])
    let menuViewData = BehaviorRelay<[MenuViewData]>(value: [])
    private weak var jogsProvider: JogsProviderProtocol?
    
    init(jogsProvider: JogsProviderProtocol?) {
        self.jogsProvider = jogsProvider
    }
    
    override func setup() {
        super.setup()
        configureMenu()
    }
    
    override func createObservers() {
        
    }
    
    func loadJogs() {
        self.inProgress.onNext(.started)
        jogsProvider?.getJogs()
            .subscribe(onSuccess: { [weak self] jogs in
                self?.inProgress.onNext(.success(true))
                self?.jogsViewData.accept(jogs)
            }, onError: { [weak self] error in
                self?.inProgress.onNext(.error(error))
            })
            .disposed(by: rxBag)
    }
    
    func jog(for indexPath: IndexPath?) -> Jog? {
        guard let jogIndex = indexPath?.row else {
            return nil
        }
        return jogsViewData.value[jogIndex]
    }
    
    private func configureMenu() {
        menuViewData.accept([
            MenuViewData(name: Constants.statistikMenuName, imageName: Constants.statisticMenuIconName),
            MenuViewData(name: Constants.feedbackMenuName, imageName: Constants.feedbackMenuIconName)
        ])
    }
}
