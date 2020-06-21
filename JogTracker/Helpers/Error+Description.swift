//
//  Error+Description.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

extension Error {

    func message () -> String {
        if let message = (self as NSError).userInfo["message"] as? String {
            return message
        }
        return (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
