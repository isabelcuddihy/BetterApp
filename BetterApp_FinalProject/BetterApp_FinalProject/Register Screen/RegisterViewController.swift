//
//  RegisterViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    

    
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
        
    }
    
 
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        registerNewAccount()
    }
    
    
}

