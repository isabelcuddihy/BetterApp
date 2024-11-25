//
//  ViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 10/21/24.
// Test Haidar Commit Comment : i am cool
// Test - Soni : the best ever

import UIKit
import FirebaseAuth
import FirebaseCore

import FirebaseFirestore
import Network

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    var chatsList = [Chat]() // list for chats in main menu
    let searchChatContactController = SearchBottomSheetController() // search bar for contacts
    var searchSheetNavController: UINavigationController!
    var messagingContact = "" // selected person to message
    var potentialContacts: [String: String] = [:] // all potential contacts as name:email
    let notificationCenter = NotificationCenter.default
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    let database = Firestore.firestore()
    
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           // Additional setup if needed
       }
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adding in a listener to track user's sign-in status
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("User is nil")
                //MARK: not signed in...
                self.currentUser = nil
                self.mainScreen.labelText.text = "Please sign in to see your profile!" // 11/24 - changed String to fit our app better. Soni
                self.mainScreen.floatingButtonAddChat.isEnabled = false // TD: you will need to update the button from AddChat to AddCompetition/Challenge to fit the Better App
                self.mainScreen.floatingButtonAddChat.isHidden = true
                
                //MARK: Reset tableView...
                self.chatsList.removeAll()
                self.mainScreen.tableViewChats.reloadData()
                //MARK: Sign in bar button...
                self.setupRightBarButton(isLoggedin: false)
            }else{
                
                //MARK: the user is signed in...
                self.currentUser = user
                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.mainScreen.floatingButtonAddChat.isEnabled = true
                self.mainScreen.floatingButtonAddChat.isHidden = false
                self.searchChatContactController.userName =  user?.displayName ?? "Anonymous"
                
                // get all most recent messages
                self.fetchChatMessages() //TD: you will need to update this for Better App
                //MARK: Logout bar button...
                self.setupRightBarButton(isLoggedin: true)
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
        
        // 11/24 - changed String to fit our app better. Soni
        title = "My Profile"
  
        //MARK: patching table view delegate and data source...
        mainScreen.tableViewChats.delegate = self
        mainScreen.tableViewChats.dataSource = self
        
        
        //MARK: removing the separator line...
        mainScreen.tableViewChats.separatorStyle = .none
        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //MARK: Put the floating button above all the views...
        view.bringSubviewToFront(mainScreen.floatingButtonAddChat)
        mainScreen.floatingButtonAddChat.addTarget(self, action: #selector(onAddChatButtonTapped), for: .touchUpInside)
      
        
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForChatRecipientSelection(notification:)),
            name: .NewChatSelected,
            object: nil)
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForNewChatsSent(notification:)),
            name: .NewChatAdded,
            object: nil)
        
    }
    
    @objc func notificationReceivedForChatRecipientSelection(notification: Notification){
        // update all users as double check
        getAllUsers { names, error in
               if let error = error {
                   print("Error fetching user names: \(error)")
               } else {
                   print("Fetched names: \(names)")
               }
           }
        if let data = notification.userInfo?["data"] as? String {
            self.messagingContact = data
            // check if conversation exists, else create one
            let userChatRef = self.database.collection("users").document(currentUser?.email ?? "").collection("chats").document(messagingContact)
            
            // Check if a conversation exists
            userChatRef.getDocument { documentSnapshot, error in
                var chatID: String = ""
                if let document = documentSnapshot, document.exists {
                                chatID = document.get("chatID") as? String ?? ""
                    self.navigateToChat(chatID: chatID, recipientName: self.messagingContact)
                            }
                
                else {
                    // Conversation doesn't exist, create a new one
                    print("Creating new conversation with \(self.messagingContact).")
         
                    let recipientEmail = self.potentialContacts[self.messagingContact]
                   
                    self.createConversation(recipientName: self.messagingContact, recipientEmail: recipientEmail ?? "")
                    
                }
                
                
                
                
            }
        }
    }
    
    @objc func notificationReceivedForNewChatsSent(notification: Notification){
        getAllUsers { names, error in
            if let error = error {
                print("Error fetching user names: \(error)")
            }
            
        }
        //new chat has been sent, refresh main page
        fetchChatMessages()
        navigationController?.popViewController(animated: true)
    }
    
    // for when a selected conversion does not exist yet
    func createConversation(recipientName: String, recipientEmail: String) {
       
        guard let currentUserEmail = self.currentUser?.email, !currentUserEmail.isEmpty,
              let currentUserName = self.currentUser?.displayName, !currentUserName.isEmpty else {
            print("Error: Current user's email or display name is missing.")
            return
        }

        guard !recipientEmail.isEmpty else {
            print("Error: Recipient email is empty.")
            return
        }

        // Create recipient's name as document ID for chat
        let userChatRef = self.database.collection("users").document(currentUserEmail).collection("chats").document(recipientName)

        userChatRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error checking existing conversation: \(error)")
                return
            }

            if let document = documentSnapshot, document.exists {
                // Chat already exists ( probably created by other user) --> this shouldn't happen because of updates every time new chats are made
                if let existingChatID = document.get("chatID") as? String {
                    print("Chat already exists with ID: \(existingChatID)")
                    self.navigateToChat(chatID: existingChatID, recipientName: recipientName)
                }
            } else {
                // Create a new chat
                let chatID = UUID().uuidString
                print("Creating new chat with ID: \(chatID)")

                
                let chatDocumentRef = self.database.collection("chats").document(chatID)

                let chatData: [String: Any] = [
                    "user1": currentUserName,
                    "user2": recipientName
                ]

                chatDocumentRef.setData(chatData) { error in
                    if let error = error {
                        print("Error creating new chat: \(error)")
                        return
                    }

                    // Add initial message
                    let messagesCollectionRef = chatDocumentRef.collection("messages")
                    let initialMessage: [String: Any] = [
                        "message": "Chat started!",
                        "sender": "System",
                        "timestamp": Timestamp(date: Date())
                    ]

                    messagesCollectionRef.addDocument(data: initialMessage) { error in
                        if let error = error {
                            print("Error adding initial message: \(error)")
                        }
                    }

                    // Add chat references for both users
                    let currentUserChatRef = self.database.collection("users").document(currentUserEmail).collection("chats").document(recipientName)
                    let recipientChatRef = self.database.collection("users").document(recipientEmail).collection("chats").document(currentUserName)

                    let chatReferenceData: [String: Any] = ["chatID": chatID]

                    // Error handling
                    currentUserChatRef.setData(chatReferenceData) { error in
                        if let error = error {
                            print("Error setting chat reference for current user: \(error)")
                            return
                        }
                    }

                    recipientChatRef.setData(chatReferenceData) { error in
                        if let error = error {
                            print("Error setting chat reference for recipient: \(error)")
                            return
                        }
                    }
                    print("Chat created successfully. Navigating to chat.")
                    // Navigate to the new chat
                    self.navigateToChat(chatID: chatID, recipientName: recipientName)
                }
            }
        }
    }



    // push to chat screen with chat ID
    func navigateToChat(chatID: String, recipientName: String) {
        let chatViewController = ChatViewController()
        chatViewController.chatID = chatID
        chatViewController.messagingContact = recipientName
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    // fetch all message chains (only most recently sent message)
    func fetchChatMessages() {
        guard let userEmail = currentUser?.email else {
            print("Current user email is nil.")
            return
        }

        self.chatsList.removeAll()

        self.database.collection("users").document(userEmail).collection("chats").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching chats: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No chats found for the user.")
                return
            }

            for document in documents {
                guard let chatID = document.get("chatID") as? String, !chatID.isEmpty else {
                    print("chatID is missing or empty for document: \(document.documentID)")
                    continue
                }

                let recipientName = document.documentID

                let lastMessageRef = self.database.collection("chats").document(chatID).collection("messages")
                    .order(by: "timestamp", descending: true)
                    .limit(to: 1)

                lastMessageRef.getDocuments { messageSnapshot, error in
                    if let error = error {
                        print("Error fetching last message for chatID \(chatID): \(error)")
                        return
                    }

                    if let messageDocument = messageSnapshot?.documents.first {
                        let message = messageDocument.get("message") as? String ?? ""
                        let sender = messageDocument.get("sender") as? String ?? "Unknown"
                        let timestamp = messageDocument.get("timestamp") as? Timestamp ?? Timestamp(date: Date())

                        let chat = Chat(chatId: chatID, name: recipientName, messageSent: message, timeStamp: timestamp)
                        self.chatsList.append(chat)
                    }

                    DispatchQueue.main.async {
                        self.mainScreen.tableViewChats.reloadData()
                    }
                }
            }
        }
    }


    // update all users via info from firestore (accounts for new registrations from different phones)

    func getAllUsers(completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            self.potentialContacts.removeAll()
            // TD: verify that this is the place where we would add functionality for user data for Better App
            let names = querySnapshot?.documents.compactMap { document -> String in
                let name = document.data()["name"] as? String ?? "Unknown"
                let email = document.data()["email"] as? String ?? ""
                print(name, email)
                self.potentialContacts[name] = email
                return name
            }
            print(self.potentialContacts)
            completion(names, nil)
            // Fetch chat messages after fetching all users
            self.fetchChatMessages()
        }
    }
    
    
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
    
    @objc func onAddChatButtonTapped(){
        setupSearchBottomSheet()
        
        present(searchSheetNavController, animated: true)
    }
    func convertTimestampToString(timestamp: Timestamp) -> String {

        let date = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}


