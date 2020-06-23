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
    static let userTokenTypeKey = "userTokenTypeKey"
}

final class AppPreferences {
    
    private let defaults = UserDefaults.standard
    
    var userToken: String? {
        get {
            return defaults.string(forKey: Constants.userTokenKey)
        }
        set {
            defaults.set(newValue, forKey: Constants.userTokenKey)
        }
    }
    
    var userTokenType: String? {
        get {
            return defaults.string(forKey: Constants.userTokenTypeKey)
        }
        set {
            defaults.set(newValue, forKey: Constants.userTokenTypeKey)
        }
    }
    
    var isUserMakeLogin: Bool {
        userToken != nil
    }
}
