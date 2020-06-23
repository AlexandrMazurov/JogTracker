//
//  NetworkLayer+Jogs.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

extension NetworkLayer: JogsNetworkProtocol {

    func jogs() -> Single<GetJogsResponse> {
        return sendRequest(provider: jogsProvider, target: JogsEndPoints.jogs(token: preferences?.userToken ?? ""))
    }
    
    func createJog(jog: Jog) -> Single<CreateJogResponse> {
        return sendRequest(provider: jogsProvider, target: JogsEndPoints.createJog(jog: jog, token: preferences?.userToken ?? ""))
    }
    
    func editJog(jog: Jog) -> Single<CreateJogResponse> {
        return sendRequest(provider: jogsProvider, target: JogsEndPoints.editJog(jog: jog, token: preferences?.userToken ?? ""))
    }
}
