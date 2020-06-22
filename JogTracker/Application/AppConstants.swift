//
//  AppConstants.swift
//  JogTracker
//
//  Created by Александр on 6/22/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import Foundation

struct AppConstants {
    static let baseUrlString = "https://jogtracker.herokuapp.com/api/v1"
    
    static var baseURL: URL {
        guard let url = URL(string: baseUrlString) else {
            fatalError("The base url was not defined")
        }
        return url
    }
}
