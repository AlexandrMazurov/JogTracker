//
//  JogsNetworkProtocol.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

protocol JogsNetworkProtocol {
    func jogs() -> Single<GetJogsResponse>
    func createJog(jog: Jog) -> Single<CreateJogResponse>
    func editJog(jog: Jog) -> Single<EditJogResponse>
}
