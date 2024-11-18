//
//  ChatViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth


class ChatViewController: UIViewController, UITableViewDataSource {
    
    
    
    
    //init first screen
    let newChatScreen = ChatView()
    let notificationCenter = NotificationCenter.default        //init phone types and default
    var chatID = ""
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var messagingContact = ""
    var senderContact = "Unknown"
    
    // TEST DUMMY DATA -Haidar 11/12
    var chatMessages: [Chat] = [
        //   Chat(name: "Haidar", messageSent: "Hello, this is Haidar", timeStamp: "11/13/24 8:00 AM"),
        //   Chat(name: "Isabel", messageSent: "Hello, this is Isabel", timeStamp: "11/13/24 8:00 AM"),
        //   Chat(name: "Soni", messageSent: "Hello, this is Soni", timeStamp: "11/13/24 8:00 AM")
    ]
    
    //boolean flag to determine if all user input data is valid and ready to show
    var valid_results:[Bool] = [false]
    
    
    override func loadView() {
        view = newChatScreen
        
    }
    
    override func viewDidLoad() {
        title = "Chat with \(messagingContact)"
        updateListofChats()
        newChatScreen.tableViewChats.dataSource = self
        newChatScreen.tableViewChats.delegate = self
        
        hideKeyboardOnTapOutside()
        // buttonSend
        newChatScreen.buttonSend.addTarget(self, action: #selector(onSendMessageButtonTapped), for: .touchUpInside)
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
    
    
    //MARK: Error  empty alert...
    func showErrorAlertEmpty(){
        let alert = UIAlertController(
            title: "Error!", message: "No values can be empty!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    
    
    //MARK: add a new contact call: add endpoint...
    func addANewMessage(messageText: String){
        
        
        
        var chat_ID: String?
        let conversationRef = self.database.collection("users").document(currentUser?.email ?? "email@email.com").collection("chats").document(self.messagingContact)
        conversationRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            if let document = documentSnapshot, document.exists {
                let chat_ID = document.get("chatID") as? String
                print("Chat ID: \(chat_ID ?? "No chat ID found")")
            } else {
                print("Document does not exist.")
            }
            
            var newChat = Chat(chatId: chat_ID ?? "", name: self.currentUser?.displayName ?? "" , messageSent: messageText, timeStamp: Timestamp(date: Date()))
            let newMessage: [String: Any] = [
                "message": newChat.messageSent,
                "sender": newChat.name,
                "timestamp": newChat.timeStamp
            ]
            let chatMessagesRef = self.database.collection("chats").document(self.chatID).collection("messages")
            chatMessagesRef.addDocument(data: newMessage) { error in
                if let error = error {
                    print("Error adding document to messages collection: \(error)")
                } else {
                    print("Message added successfully to chat with ID: \(self.chatID)")
                    self.updateListofChats() // Refresh messages
                }
            }
            self.updateListofChats()
        }
        
    }
    
    func updateListofChats() {
        
        guard !self.chatID.isEmpty else {
                print("Error: chatID is empty.")
                return
            }
        
        var recipients: String = ""
        
        if let userEmail = currentUser?.email {
            // Access the document
            let docRef = self.database.collection("users").document(userEmail).collection("chats").document(messagingContact)
            
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
                            
                            self.chatMessages.removeAll() // Clear the current chat list before appending
                            
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
                                self.chatMessages.append(newChat)
                            }
                            
                    
                                self.newChatScreen.tableViewChats.reloadData()
                            
                           
                        }
                        self.newChatScreen.tableViewChats.reloadData()
                    }
                    else {
                        print("chatID field does not exist")
                    }
                }
            }
        }}
    

    
    //MARK: submit button tapped action...
    @objc func onSendMessageButtonTapped(){
        
        var newMessageText = ""
        
        //Check VALID NAME
        
        let inputText = newChatScreen.textViewNewMessageBox.text // changed to .textViewMessage -Haidar
        
        if let unwrappedText  = inputText{
            
            if(unwrappedText.isEmpty){ //The user didn't put anything...
                valid_results[0] = false
                showErrorAlertEmpty()
                
            }
            
            else{ //The user put some texts...
                
                newMessageText = unwrappedText
                valid_results[0] = true
            }
            
        }
        
        
        //All values are cleared - SEND TO A CELL?
        if valid_results.contains(false) == false{
            
            addANewMessage(messageText: newMessageText)
            newChatScreen.textViewNewMessageBox.text = ""
            
            
        }
        
        
    }
    
    // Convert the Timestamp to a Date
    func convertTimestampToString(timestamp: Timestamp) -> String {
        
        let date = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
}



// extention added -Haidar 11/12
extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! IndividualChatTableViewCell
        cell.labelSenderName.text = chatMessages[indexPath.row].name
        cell.labelMessageSent.text = chatMessages[indexPath.row].messageSent
        cell.labelTimeStamp.text = convertTimestampToString(timestamp: chatMessages[indexPath.row].timeStamp)
        
        return cell
    }
}






