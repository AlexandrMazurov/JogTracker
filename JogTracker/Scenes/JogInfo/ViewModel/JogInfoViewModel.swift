//
//  JogInfoViewModel.swift
//  JogTracker
//
//  Created by Александр on 6/24/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

enum JogInfoAction {
    case edit(jog: Jog?), addJog
}

private enum Constants {
    static let editButtonName = "Edit"
    static let createButtonName = "Create"
}

class JogInfoViewModel: BaseViewModel {
    
    let date = BehaviorRelay<Date>(value: Date())
    let distance = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    
    let actionButtonName = BehaviorRelay<String?>(value: nil)
    let acceptStartValues = BehaviorRelay<Jog?>(value: nil)
    let isDataValid = BehaviorRelay<Bool?>(value: nil)
    let completionActionState = BehaviorRelay<Bool?>(value: nil)
    
    private var jogInfoAction: JogInfoAction?
    private weak var jogProvider: JogsProviderProtocol?
    
    init(action: JogInfoAction?, jogProvider: JogsProviderProtocol?) {
        self.jogInfoAction = action
        self.jogProvider = jogProvider
    }
    
    override func setup() {
        super.setup()
        configureState()
    }
    
    override func createObservers() {
    
    }
    
    private func configureState() {
        guard let action = jogInfoAction else {
            print("Action unresolved")
            return
        }
        switch action {
        case .edit(let jog):
            actionButtonName.accept(Constants.editButtonName)
            acceptStartValues.accept(jog)
        case .addJog:
            actionButtonName.accept(Constants.createButtonName)
            acceptStartValues.accept(nil)
        }
    }
    
    func completeActions() {
        guard let actionType = jogInfoAction,
            let distance = Float(distance.value),
            let time = Float(time.value) else {
                isDataValid.accept(false)
            print("Action unresolved")
            return
        }
        switch actionType {
        case .edit(let jog):
            self.distance.accept(distance.description)
            self.time.accept(time.description)
            self.date.accept(jog?.date ?? Date())
            updateJog(jog)
        case .addJog:
            createJog()
        }
    }
    
    private func updateJog(_ jog: Jog?) {
        guard var jog = jog else {
            return
        }
        jog.date = Date(timeIntervalSinceReferenceDate: date.value.timeIntervalSinceReferenceDate/10)
        jog.distance = Float(distance.value) ?? .zero
        jog.time = Float(time.value) ?? .zero
        self.inProgress.onNext(.started)
        jogProvider?.editJog(jog: jog)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.inProgress.onNext(.success(isSuccess))
                self?.completionActionState.accept(isSuccess)
            }, onError: { [weak self] error in
                self?.inProgress.onNext(.error(error))
            }).disposed(by: rxBag)
    }
    
    private func createJog() {
        let jog = Jog(id: nil,
                      userId: nil,
                      distance: Float(distance.value) ?? .zero,
                      time: Float(time.value) ?? .zero,
                      date: Date(timeIntervalSinceReferenceDate: date.value.timeIntervalSinceReferenceDate/10))
        self.inProgress.onNext(.started)
        jogProvider?.createJog(jog: jog)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.inProgress.onNext(.success(isSuccess))
                self?.completionActionState.accept(isSuccess)
            }, onError: { [weak self] error in
                self?.inProgress.onNext(.error(error))
            }).disposed(by: rxBag)
    }
}
