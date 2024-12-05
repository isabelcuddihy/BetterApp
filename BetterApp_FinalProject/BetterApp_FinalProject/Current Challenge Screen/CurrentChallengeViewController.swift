//
//  CurrentChallengeViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth


class CurrentChallengeViewController: UIViewController {
    
    //init first screen
    let currentChallengeScreen = CurrentChallengeView()
    let notificationCenter = NotificationCenter.default        //init phone types and default
    var competitionID = ""
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var challenger = ""
    var chatID = ""
    
    
    override func loadView() {
        view = currentChallengeScreen
        
    }
    
    override func viewDidLoad() {
        title = "Current Challenge"
      //  updateListofChats()
       
        hideKeyboardOnTapOutside()
    
    }
    
    
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
    
    //MARK: Error  empty alert...
    func showErrorAPI(){
        let alert = UIAlertController(
            title: "Error!", message: "API for note storage could not be reached",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    

    
    func updateSteps() {
        
        guard !self.chatID.isEmpty else {
                print("Error: chatID is empty.")
                return
            }
        
        var recipients: String = ""
        
        if let userEmail = currentUser?.email {
            // Access the document
            let docRef = self.database.collection("users").document(userEmail).collection("chats").document(challenger)
            
            // Fetch the document data
            docRef.getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                // Access the chatID field from the document
                
                let recipientRef = self.database.collection("chats").document(self.chatID)
                
                // Fetch recipient information
                recipientRef.getDocument { recipientSnapshot, error in
                    if let error = error {
                        print("Error finding users: \(error)")
                        return
                    }
                    
                    let recipientData = recipientSnapshot
                    
                    
                    // Determine the recipient is user or not
                    if let user1 = recipientData?.get("user1") as? String, user1 != self.currentUser?.displayName {
                        recipients = user1
                    } else if let user2 = recipientData?.get("user2") as? String {
                        recipients = user2
                        
                        
                        // Fetch messages for the chat
                        let messageRef = self.database.collection("chats").document(self.chatID).collection("messages")
                        messageRef.getDocuments { querySnapshot, error in
                            if let error = error {
                                print("Error getting messages: \(error)")
                                
                            }
                            
                          //  self.chatMessages.removeAll() // Clear the current chat list before appending
                            
                            // Process each message document
                            for messageDocument in querySnapshot?.documents ?? [] {
                                let sender = messageDocument.get("sender") as? String
                                let message = messageDocument.get("message") as? String
                                let timeStamp = messageDocument.get("timestamp") as? Timestamp
                                
                                let newChat = Chat(
                                    chatId: self.chatID,
                                    name: sender ?? "",
                                    messageSent: message ?? "",
                                    timeStamp: timeStamp ?? Timestamp(date: Date())
                                )
                             //   self.chatMessages.append(newChat)
                            }
     
                        }
                
                    }
                    else {
                        print("chatID field does not exist")
                    }
                }
            }
        }}
    

    
   
    
}









