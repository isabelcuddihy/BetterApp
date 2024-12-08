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
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsersFromDatabase()
        
        
        //MARK: setting up Table View data source and delegate...
        searchSheet.tableViewSearchResults.delegate = self
        searchSheet.tableViewSearchResults.dataSource = self
        
        
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
        print(namesDatabase)
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
        print(dataToSend)
                NotificationCenter.default.post(name: .NewChallengerSelected, object: nil, userInfo: ["data": dataToSend])
                self.dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
}



  
