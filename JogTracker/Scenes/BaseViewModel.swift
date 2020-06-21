//
//  BaseViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum Result<OutputType> {
    case started
    case success(OutputType)
    case error(Error)
}

public class BaseViewModel {
    let rxBag = DisposeBag()
    let inProgress = PublishSubject<Result<Bool>?>()
    
    func setup() {
        createObservers()
    }
    func createObservers() {}
}
