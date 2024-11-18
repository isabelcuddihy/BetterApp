//
//  RightBarButtonManager.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//
import Foundation
import UIKit
import FirebaseAuth

extension ViewController{
    func setupRightBarButton(isLoggedin: Bool){
        if isLoggedin{
            //MARK: user is logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
            
        }else{
            //MARK: not logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "person.fill.questionmark"),
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Sign in",
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
        }
    }
    
    @objc func onSignInBarButtonTapped(){
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue.",
            preferredStyle: .alert)
        
        //MARK: setting up email textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        //MARK: setting up password textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        //MARK: Sign In Action...
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {(_) in
            if let email = signInAlert.textFields![0].text,
               let password = signInAlert.textFields![1].text{
                //MARK: sign-in logic for Firebase...
               
                if self.validateEmail(email: email) && self.validatePassword(password: password){
                    self.signInToFirebase(email: email, password: password)
                    
                }
            }
        })
        
        //MARK: Register Action...
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
            //MARK: logic to open the register screen...
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        })
        
        //MARK: action buttons...
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true, completion: {() in
            //MARK: hide the alerton tap outside...
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    func signInToFirebase(email: String, password: String){
        //MARK: can you display progress indicator here?
        //MARK: authenticating the user...
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                print("Sign-in successful...")
            }else{
                let alert = UIAlertController(
                    title: "Error!", message: "Username or Password is invalid. Please try again or register.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
            }
        }
                           
                          ) }
    


    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }
    
    // Mark: Error  email alert ...
        func showErrorAlertEmail(){
            let alert = UIAlertController(
                title: "Error!", message: "Email must in format examplename@company.com",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,64}"
           
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
       }
    func validateEmail(email:Optional<String>)->Bool{
        if let uwEmail = email{
            if uwEmail.isEmpty{
                let alert = UIAlertController(
                    title: "Error!", message: "Fields cannot be empty.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
                return false
            }
            
            else if !isValidEmail(uwEmail){
                showErrorAlertEmail()
                return false
            }
            else{
                return true
            }
        }
        return true
    }
    
    func validatePassword(password: Optional<String>)-> Bool{
        if let uwPassword = password{
            if uwPassword.isEmpty{
                let alert = UIAlertController(
                    title: "Error!", message: "Fields cannot be empty.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
                return false
            }
            else if uwPassword.count < 6{
                let alert = UIAlertController(
                    title: "Error!", message: "Password must be at least 6 characters.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
                return false
            }
            
            else{
                return true
            }
        }
        return true
    }
        
    
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                }catch{
                    print("Error occured!")
                }
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }
    
}
