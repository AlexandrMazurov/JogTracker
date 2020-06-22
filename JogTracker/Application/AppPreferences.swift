//
//  AppPreferences.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let userTokenKey = "userTokenKey"
}

final class AppPreferences {
    
    private let defaults = UserDefaults.standard
    
    var userToken: String? {
        get {
            guard let token = defaults.string(forKey: Constants.userTokenKey) else {
                return nil
            }
            return token
        }
        set {
            defaults.set(newValue, forKey: Constants.userTokenKey)
        }
    }
    
    var isUserMakeLogin: Bool {
        userToken != nil
    }
}
