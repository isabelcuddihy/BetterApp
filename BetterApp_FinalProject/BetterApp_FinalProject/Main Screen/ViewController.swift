//
//  ViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 10/21/24.
// Test Haidar Commit Comment : i am cool


import UIKit
import FirebaseAuth
import FirebaseCore

import FirebaseFirestore
import Network

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    // creating instance of our HealthManager
    let healthManager = HealthManager()
    var statusLabel: UILabel?

    let notificationCenter = NotificationCenter.default
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    let database = Firestore.firestore()
    
    var Competition_ID = "None"
    
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           
       }
    
    override func loadView() {
        view = mainScreen
        self.title = "Welcome"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adding in a listener to track user's sign-in status
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                self.title = "Welcome"
                self.mainScreen.labelText.isHidden = false
                print("User is nil")
                //MARK: not signed in...
                self.currentUser = nil

               
                self.mainScreen.labelText.text = "Please sign in to see your profile!" 
                
                self.mainScreen.buttonCompetition.isEnabled = false
                self.mainScreen.buttonCompetition.isHidden = true
          

                //MARK: Sign in bar button...
                self.setupRightBarButton(isLoggedin: false)
            }else{
                
                //MARK: the user is signed in...
                self.currentUser = user
                self.title = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.buttonCompetition.isEnabled = true
                self.mainScreen.buttonCompetition.isHidden = false
                
                self.loadUserData()

                //MARK: Logout bar button...
                self.setupRightBarButton(isLoggedin: true)
                self.mainScreen.buttonCompetition.addTarget(self, action: #selector(self.onChallengeButtonTapped), for: .touchUpInside)
            }
            
        }
        
    }
    
   
    func loadUserData(){
        self.Competition_ID = self.get_competition_ID()
        if self.Competition_ID != "None"{
            
            mainScreen.buttonCompetition.setTitle("View Challenge", for: .normal)
            mainScreen.buttonCompetition.backgroundColor = .green
            
            }
        else{
            mainScreen.buttonCompetition.setTitle("Create Challenge", for: .normal)
            mainScreen.buttonCompetition.backgroundColor = .red
        }
        self.mainScreen.labelText.isHidden = true
        self.mainScreen.labelWins.isHidden = false
        self.mainScreen.labelLosses.isHidden = false
        self.get_wins()
        self.get_losses()
        
        
    }

    

    
    func get_wins(){
        // Pull the competition from Firestore
        if let userEmail = currentUser?.email {
            
            // Access the document matching the provided competition ID
            let docRef = self.database.collection("users").document(userEmail)
            
            // Fetch the document data for specific competition
            docRef.getDocument { documentSnapshot, error in
                //get any errors
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                // protection if document doesn't exist
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                // Access the user information from the document
                let UserData = documentSnapshot
                
                
                if let wins = UserData?.get("wins") as? String{
                    self.mainScreen.labelWins.text = "Wins: \(wins)"
                }
            }
        }
    }
    
    

    func get_losses(){
        // Pull the competition from Firestore
        if let userEmail = currentUser?.email {
            
            // Access the document matching the provided competition ID
            let docRef = self.database.collection("users").document(userEmail)
            
            // Fetch the document data for specific competition
            docRef.getDocument { documentSnapshot, error in
                //get any errors
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                // protection if document doesn't exist
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                // Access the user information from the document
                let UserData = documentSnapshot
                
                
                if let losses = UserData?.get("losses") as? String{
                    self.mainScreen.labelLosses.text = "Losses: \(losses)"
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Removing the auth listener when view disappears to prevent unnecessary changes
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "Welcome!"
        

        // Check HealthKit authorization and update status
        healthManager.requestAuthorization { [weak self] success in
          DispatchQueue.main.async {
              if success {
                  self?.statusLabel?.text = "HealthKit Access Granted"

              } else {
                  self?.statusLabel?.text = "Authorization Failed"
              }
          }
      }

        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
       

        
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForNewChallenge(notification:)),
            name: .NewChallenge,
            object: nil)
  
        
    }
    
    
    @objc func notificationReceivedForNewChallenge(notification: Notification){
      
        if let data = notification.userInfo?["data"] as? String {
            self.Competition_ID = data
        if self.Competition_ID != "None"{
            mainScreen.buttonCompetition.tintColor = .green
            mainScreen.buttonCompetition.setTitle("View Challenge", for: .normal)
            mainScreen.buttonCompetition.setTitleColor(UIColor.white, for: .normal)
            
            }
                
            }
        }
    
    
   
  
    @objc func onChallengeButtonTapped(){
        self.Competition_ID = get_competition_ID()
        print("competition_ID is \(self.Competition_ID)")


        if self.Competition_ID == "None"{
            let createChallengeScreen = CreateChallengeController()

            self.navigationController?.pushViewController(createChallengeScreen, animated: true)
        }
        else{
            let currentChallengeScreen = CurrentChallengeViewController()
            currentChallengeScreen.competitionID = self.Competition_ID

            self.navigationController?.pushViewController(currentChallengeScreen, animated: true)
        }
    }
    
    func get_competition_ID()-> String{
        // Pull the competition from Firestore
        if let userEmail = currentUser?.email {
            
            // Access the document matching the provided competition ID
            let docRef = self.database.collection("users").document(userEmail)
            
            // Fetch the document data for specific competition
            docRef.getDocument { documentSnapshot, error in
                //get any errors
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                // protection if document doesn't exist
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                // Access the user information from the document
                let UserData = documentSnapshot
                
                
                    if let competition_ID = UserData?.get("Competition_ID") as? String{
                    
                    
                    
                    if competition_ID == "None"{
                        self.Competition_ID = competition_ID
                        
                    }
                    else{
                        self.Competition_ID =  competition_ID
                       
                    }
                }
                else{
                    print("Could not fetch competition_ID")
                }}
        }

        return Competition_ID
    }

}
