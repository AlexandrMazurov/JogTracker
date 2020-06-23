//
//  JogsProvider.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class JogsProvider: JogsProviderProtocol {
    
    private let network: JogsNetworkProtocol?
    
    init(network: JogsNetworkProtocol?) {
        self.network = network
    }

    func getJogs() -> Single<[Jog]> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Jogs API was not injected"))
                return Disposables.create()
            }
            let disposable = network.jogs()
                .subscribe(onSuccess: { data in
                    print(data.response)
                    single(SingleEvent.success(data.response.jogs))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
    
    func createJog(jog: Jog) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Jogs API was not injected"))
                return Disposables.create()
            }
            let disposable = network.createJog(jog: jog)
                .subscribe(onSuccess: { data in
                    print(data.response)
                    single(SingleEvent.success(true))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
    
    func editJog(jog: Jog) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let network = self?.network else {
                single(SingleEvent.error("Jogs API was not injected"))
                return Disposables.create()
            }
            let disposable = network.editJog(jog: jog)
                .subscribe(onSuccess: { data in
                    print(data.response)
                    single(SingleEvent.success(true))
                }, onError: { error in
                    single(SingleEvent.error(error))
                })
            return Disposables.create([disposable])
        }
    }
}
