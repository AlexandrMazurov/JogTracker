//
//  JogsViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class JogsViewModel: BaseViewModel {
    
    let jogsViewData = BehaviorRelay<[Jog]>(value: [])
    private weak var jogsProvider: JogsProviderProtocol?
    
    init(jogsProvider: JogsProviderProtocol?) {
        self.jogsProvider = jogsProvider
    }
    
    override func setup() {
        super.setup()
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
}
