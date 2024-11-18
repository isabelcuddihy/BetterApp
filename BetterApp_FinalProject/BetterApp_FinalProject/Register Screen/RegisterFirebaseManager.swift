//
//  RegisterFirebaseManager.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

extension RegisterViewController{
    
    
    
    //MARK: hide keyboard logic...
    func hideKeyboardOnTapOutside(){
        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    
    func validateName(name: Optional<String>)-> Bool{
        if let uwName = name{
            if uwName.isEmpty{
                let alert = UIAlertController(
                    title: "Error!", message: "Fields cannot be empty.",
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
    
    
    func validateConfirmPassword(confirmPassword: Optional<String>, password:String)-> Bool{
        if let uwPassword = confirmPassword{
            if uwPassword.isEmpty{
                let alert = UIAlertController(
                    title: "Error!", message: "Fields cannot be empty.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
                return false
            }
            else if uwPassword != password{
                let alert = UIAlertController(
                    title: "Error!", message: "Passwords do not Match.",
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
    
    func registerNewAccount(){
        var valid_results:[Bool] = [false, false, false, false]
        //MARK: display the progress indicator...
        showActivityIndicator()
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text,
           let confirmPassword = registerView.textFieldConfirmPassword.text{
            valid_results[0] = validateName(name: name)
            valid_results[1] = validateEmail(email: email)
            valid_results[2] = validatePassword(password: password)
            valid_results[3] = validateConfirmPassword(confirmPassword: confirmPassword, password: password)
            
            //Validations....
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    let contact = Contact(name: name, email: email)
                    self.saveContactToFireStore(contact: contact)
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    // add details to FireStore (name, email) -> NOT PASSWORD
                    
                }else{
                    //MARK: there is a error creating the user...
                    print("Error creating the user")
                }
            })
        }
    }
        
        
        
        //MARK: We set the name of the user after we create the account...
        func setNameOfTheUserInFirebaseAuth(name: String){
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: {(error) in
                if error == nil{
                
                    //MARK: hide the progress indicator...
                    self.hideActivityIndicator()
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    //MARK: there was an error updating the profile...
                    print("Error occured: \(String(describing: error))")
                }
            })
        }
        
        
        
        //MARK: logic to add a contact to Firestore...
        func saveContactToFireStore(contact: Contact){
            
            let collectionUsers = self.database
                .collection("users")
                .document(contact.email)
            
            collectionUsers.setData([
                   "name": contact.name,
                   "email": contact.email
               ])
            
            let chatsCollectionRef = collectionUsers.collection("chats")
            chatsCollectionRef.document("placeholder").setData([
                "chatID:": "CFws1H5hqkaAPqe9n80A"
                    ])
      
        }
    
}
