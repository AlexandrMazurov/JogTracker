//
//  LoginViewController.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    private var loginViewModel: BaseViewModel? {
        return viewModel as? LoginViewModel
    }
    
    override func createObservers() {
        super.createObservers()
        
        guard let viewModel = loginViewModel else {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
