//
//  CreateJogResponse.swift
//  JogTracker
//
//  Created by Александр on 6/23/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

typealias EditJogResponse = CreateJogResponse

struct CreateJogResponse: Decodable {
    let response: JogResponse
}

struct JogResponse: Decodable {
    let id: Int
}
