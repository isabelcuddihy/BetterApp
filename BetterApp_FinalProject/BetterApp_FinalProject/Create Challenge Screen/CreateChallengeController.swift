//
//  CreateChallengeController.swift
//  BetterApp_FinalProject
//
//  Created by Haidar Halawi on 11/21/24.
//

import UIKit
import HealthKit // import healthkit
import FirebaseFirestore
import FirebaseAuth

class CreateChallengeController: UIViewController {
    
    let createChallengeView = CreateChallengeView()
    //Login Authorization for User
    let currentUser = Auth.auth().currentUser
    
    //MARK: by default day selected (7)
    var selectedType = "7"
    
    let searchChatContactController = SearchBottomSheetController() // search bar for contacts
    var searchSheetNavController: UINavigationController!
    
    let healthStore = HKHealthStore() // create healthsore instance to access data
    
    var potentialContacts: [String: String] = [:] // all potential contacts as name:email -> key value meil pair
    
    // notification center to grab name + ottehr important data
    let notificationCenter = NotificationCenter.default
    
    let database = Firestore.firestore()
    
    var userToChallengeName = "" // selected user to message


    
    override func loadView() {
        view = createChallengeView
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        //MARK:  adding menue to buttonSelectDays
        createChallengeView.buttonSelectDays.menu = getMenuTypes()
        
        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onChooseFriendButtonTapped), for: .touchUpInside)
       
        // test receiving name data from notification center (using observer to see if NewCHallengerSelected Notification is called)
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForNewChallengerSelected(notification:)),
            name: .NewChallengerSelected,
            object: nil)
       

    }
    
    //MARK: menu for buttonSelectDays setup...
    func getMenuTypes() -> UIMenu{
        var menuItems = [UIAction]()
        
        for type in Utilities.types{
            let menuItem = UIAction(title: type,handler: {(_) in
                self.selectedType = type
                self.createChallengeView.buttonSelectDays.setTitle(self.selectedType, for: .normal)
            })
            menuItems.append(menuItem)
        }
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    // MARK: PLACEHOLDER
    func setupSearchBottomSheet(){
        //MARK: setting up bottom search sheet...
        searchSheetNavController = UINavigationController(rootViewController: searchChatContactController)
        
        // MARK: setting up modal style...
        searchSheetNavController.modalPresentationStyle = .pageSheet
        
        if let bottomSearchSheet = searchSheetNavController.sheetPresentationController{
            bottomSearchSheet.detents = [.medium(), .large()]
            bottomSearchSheet.prefersGrabberVisible = true
        }
    }
    
    @objc func onChooseFriendButtonTapped(){
        setupSearchBottomSheet()
        
        present(searchSheetNavController, animated: true)
    }
    
//    @objc func onChooseFriendButtonTapped(){
//        requestHealthKitAuthorization() // created this function to force steps data from health kit. trying to figure out where its being printed
//        print("onChooseFriendButtonTapped")
//    }
    
    // This function serves to write data to database (both user names and chat IDs for now)
    @objc func notificationReceivedForNewChallengerSelected(notification: Notification){
       
        
        if let data = notification.userInfo?["data"] as? String {
            // data (name) recived of the person we want to talk to
            self.userToChallengeName = data
            
            print(potentialContacts)
            print(userToChallengeName)
            if self.potentialContacts.isEmpty {
                print("Dictionary is empty")
            }
            
            // key of persons name to get email (which is the value)
            let userToChallengeEmail =  self.potentialContacts[self.userToChallengeName] // name:email
            
            // check if competition exists (for current user), else create one
            // getting pathway right now to curr user fields
            let userCompRef = self.database.collection("users").document(userToChallengeEmail ?? "")
            
            // Check if a conversation exists
            userCompRef.getDocument { documentSnapshot, error in
                var compID: String = ""
                if let document = documentSnapshot, document.exists {
                    compID = document.get("Competition_ID") as? String ?? ""
                    
                    if compID == "none" {
                        print("user \(self.userToChallengeName) is alread in a competition")
                    }
                    // pushes us to current chat if it exixsts
                    return
//                    self.navigateToChat(chatID: chatID, recipientName: self.userToChallenge)
                            }
                
                else {
                    // challenge doesn't exist, create a new one
                    print("Creating new conversation with \(self.userToChallengeName).")
         
//                    // key of persons name to get email (which is the value)
//                    let recipientEmail =                self.potentialContacts[self.userToChallengeName] // name:email
//                   // functionality for setting up a new chat
//                    self.createConversation(recipientName: self.messagingContact, recipientEmail: recipientEmail ?? "")
                    
                }
                
                
            }
        }
    }
    

    // update all users via info from firestore (accounts for new registrations from different phones)
    func getAllUsers() {
     
        // select user account within firestore
        if let userEmail = currentUser?.email {
            
            self.database.collection("users").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("An error occurred: \(error)")
                    
                    return
                }
                //        print("no errors found, continuing")
                print("printing potential contacts b4 removing:\(self.potentialContacts)")
                self.potentialContacts.removeAll()
                let names = querySnapshot?.documents.compactMap { document -> String in
                    let name = document.data()["name"] as? String ?? "Unknown"
                    let email = document.data()["email"] as? String ?? ""
                    print(name, email)
                    self.potentialContacts[name] = email
                    return name
                }
                print(self.potentialContacts)
             
            }
        }
        else{
            print("Login error")
        }
    }
    
}
