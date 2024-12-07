//
//  SearchBottomSheetViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchBottomSheetController: UIViewController {
    
    
    let searchSheet = SearchBottomSheetView()
    let database = Firestore.firestore()
    //MARK: the list of names...
    var namesDatabase :[String] = []
    var currentUser:FirebaseAuth.User?
    //MARK: the array to display the table view...
    var namesForTableView = [String]()
    var userToChallengeName = "" // selected user to message
    
    
    
    var potentialContacts: [String: String] = [:] // all potential contacts as name:email -> key value meil pair
    
    // notification center to grab name + ottehr important data
    let notificationCenter = NotificationCenter.default
    
    
    
    
    override func loadView() {
        view = searchSheet
//        self.getAllUsers(completion: ([String]?, Error?) -> Void)
//        print(potentialContacts)
        
        // test receiving name data from notification center (using observer to see if NewCHallengerSelected Notification is called)
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForNewChallengerSelected(notification:)),
            name: .NewChallangerSelected,
            object: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsersFromDatabase()
        
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        //MARK: setting up Search Bar delegate...
        searchSheet.searchBar.delegate = self
        
        //MARK: initializing the array for the table view with all the names...
        namesForTableView = namesDatabase
    }
    
    func allUsersFromDatabase(){
        //code omitted...
        
        //MARK: Observe Firestore database to display the contacts list...
        
        self.database.collection("users")
            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                if let documents = querySnapshot?.documents{
                    self.namesDatabase.removeAll()
                    for document in documents{
                        do{
                            let contact = document.get("name") as? String
                            if let uwName = contact{
                                if uwName.isEmpty{
                                    print("ERROR")
                                }
                                else{
                                    if uwName != self.currentUser?.displayName{
                                        self.namesDatabase.append(uwName)
                                    }
                                }
                            }
                            
                        }catch{
                            print("error")
                        }
                    }
                    self.namesDatabase.sort()
                    self.namesForTableView = self.namesDatabase
                    self.searchSheet.tableViewSearchResults.reloadData()
                }
            })
    }
    
    // This function serves to write data to database (both user names and chat IDs for now)
    @objc func notificationReceivedForNewChallengerSelected(notification: Notification){
        // update all users as double check (get name:email key:value pairs
        getAllUsers { names, error in
            if let error = error {
                print("Error fetching user names: \(error)")
            } else {
                print("Fetched names: \(names)")
            }
        }
        if let data = notification.userInfo?["data"] as? String {
            // data (name) recived of the person we want to talk to
            self.userToChallengeName = data
            
            print(potentialContacts)
            print(userToChallengeName)
            print(self.potentialContacts[self.userToChallengeName])
            // key of persons name to get email (which is the value)
            let userToChallengeEmail =                self.potentialContacts[self.userToChallengeName] // name:email
            
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
    func getAllUsers(completion: @escaping ([String]?, Error?) -> Void) {
        print("getAllUsersIsBeingCalled")
    let db = Firestore.firestore()
    db.collection("users").getDocuments { (querySnapshot, error) in
        if let error = error {
            print("test")
            completion(nil, error)
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
        completion(names, nil)
//        // Fetch chat messages after fetching all users
//        self.fetchChatMessages()
    }
}
    
    
    
    
    
    
}
    

    
    
    
    
    



    
    //MARK: adopting Table View protocols...
extension SearchBottomSheetController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Configs.tableViewContactsID, for: indexPath) as! SearchTableCell
        
        cell.labelTitle.text = namesForTableView[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToSend = namesForTableView[indexPath.row]
                NotificationCenter.default.post(name: .NewChallangerSelected, object: nil, userInfo: ["data": dataToSend])
                self.dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
}
    
    //MARK: adopting the search bar protocol...
    extension SearchBottomSheetController: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == ""{
                namesForTableView = namesDatabase
            }else{
                self.namesForTableView.removeAll()
                
                for name in namesDatabase{
                    namesForTableView = namesDatabase.filter { $0.localizedCaseInsensitiveContains(searchText) }
                }
            }
            self.searchSheet.tableViewSearchResults.reloadData()
        }
        
        
    }

