//
//  JogsProviderProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

protocol JogsProviderProtocol: class {
    func getJogs() -> Single<[Jog]>
    func createJog(jog: Jog) -> Single<Bool>
    func editJog(jog: Jog) -> Single<Bool>
}
