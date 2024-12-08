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
    
    var userToChallengeEmail = ""
    
    //Login Authorization for User
    let currentUser = Auth.auth().currentUser
    


    
    override func loadView() {
        view = createChallengeView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:  adding menue to buttonSelectDays
        createChallengeView.buttonSelectDays.menu = getMenuTypes()
        
        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onChooseFriendButtonTapped), for: .touchUpInside)
        
        // Request authorization when the view loads
        requestHealthKitAuthorization()
        
        print("this statement is printed after view is loaded")
        self.getAllUsers()

        createChallengeView.buttonChallenge.addTarget(self, action: #selector(onChooseChallengeButtonTapped), for: .touchUpInside)
        
        // test receiving name data from notification center (using observer to see if NewCHallengerSelected Notification is called)
        notificationCenter.addObserver(
            self, selector: #selector(notificationReceivedForNewChallengerSelected(notification:)),
            name: .NewChallangerSelected,
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
        if createChallengeView.textFieldSteps.text!.isEmpty {
            showInvalidStepsAlert()
            return
        }
        
        setupSearchBottomSheet()
        
        present(searchSheetNavController, animated: true)
    }
    
    @objc func onChooseChallengeButtonTapped(){
        print("onChooseFriendButtonTapped")
        print("Creating new conversation with \(self.userToChallengeName).")
        
        // functionality for setting up a new chat
        self.createCompetition(userChallengedName: self.userToChallengeName, userChallengedEmail: userToChallengeEmail ?? "")
    }
    
    
    // Request HealthKit authorization
    func requestHealthKitAuthorization() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step Count unavailable.")
            return
        }
        
        let readTypes: Set<HKObjectType> = [stepType]
        
        // Request permission from the user
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                print("HealthKit authorization granted.")
                // Fetch steps for the last day once authorized
                self.fetchStepsForLastDay()
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Fetch and print steps for the last day
    func fetchStepsForLastDay() {
        // TODO: Q: Ask team how is this line know how to access the step data"? what is it doing?
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step Count type is unavailable.")
            return
        }
        
        // Define the start and end date for the last day
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Error fetching steps: \(error.localizedDescription)")
                return
            }
            
            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                print("Total steps in the last day: \(Int(steps))")
            } else {
                print("No steps data found for the last day.")
            }
        }
        
        // Execute the query
        healthStore.execute(query)
        
    }
    
    // This function serves to write data to database (both user names and chat IDs for now)
    @objc func notificationReceivedForNewChallengerSelected(notification: Notification){
        if let data = notification.userInfo?["data"] as? String {
            // data (name) recived of the person we want to talk to
            self.userToChallengeName = data
            
            print("potential users: \(potentialContacts)")
            print("user being challenged: \(userToChallengeName)")
            print("email (key:value) of user being challenged \(self.potentialContacts[self.userToChallengeName])")
            
            // userBeingChallenged's email
            let userToChallengeEmail = self.potentialContacts[self.userToChallengeName] // name:email
            
            // check if competition exists (for current user), else create one
            // getting pathway right now to curr user fields
            let userCompRef = self.database.collection("users").document(userToChallengeEmail ?? "")
            
            // Check if a conversation exists
            userCompRef.getDocument { documentSnapshot, error in
                var compID: String = ""
                if let document = documentSnapshot, document.exists {
                    // get competitionID
                    compID = document.get("Competition_ID") as? String ?? ""
                    
                    if compID != "None" {
                        print("user \(self.userToChallengeName) is already in a competition")
                        // Preview Alert User is in competition
                        self.showUserInCompetitionAlert()
                        return
                    } else {
                        // save name: string of user to challenge
                        // Update challenged user label
                        self.userToChallengeEmail = userToChallengeEmail!
                        self.createChallengeView.labelFriendName.text = self.userToChallengeName
                        
                    }
                    
                    
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
    }
    
    // for when a selected conversion does not exist yet
    func createCompetition(userChallengedName: String, userChallengedEmail: String) {
        
        // get current user name and email
        guard let currentUserEmail = self.currentUser?.email, !currentUserEmail.isEmpty,
              let currentUserName = self.currentUser?.displayName, !currentUserName.isEmpty else {
            print("Error: Current user's email or display name is missing.")
            return
        }
        
        guard !userChallengedEmail.isEmpty else {
            print("Error: Recipient email is empty.")
            showSelectFriendFirstAlert()
            return
        }
        
        let numberOfDays = createChallengeView.buttonSelectDays.currentTitle
        guard let numberOfSteps = createChallengeView.textFieldSteps.text, !numberOfSteps.isEmpty
        else {
            print("Error: Numebr of steps is invalid.")
            return
        }
        
        
        
        // create competitionID
        let compID = UUID().uuidString
        print("Creating new chat with ID: \(compID)")
        
        // MARK: TOMORROW UPDATE BOTH COLLECTIONS OF USERS & COMPETION TO REFLECT CHALLENG UPDATES
        
        // update both Competition_ID of the user and challenger to the new compID
        // Add chat references for both users
        // first let is address for current user and second is for recipient
        let currentUserCompRef = self.database.collection("users").document(currentUserEmail)
        let challengedUserCompRef = self.database.collection("users").document(userChallengedEmail)
        
        let competionCollectionRef = self.database.collection("competitions").document(compID)
        
        
        // putting in compID name created into both users accounts
        let userCollectionData: [String: Any] = ["Competition_ID": compID]
        
        let compCollectionData: [String: Any] = ["number_of_days": Int(numberOfDays!), "number_of_steps": Int(numberOfSteps), "user1": currentUserName, "user2": self.userToChallengeName, "user1_last_update_of_steps": 0, "user1_steps": 0, "user2_last_update_of_steps": 0, "user2_steps": 0]
        // Error handling
        
        // setting data in current users account
        currentUserCompRef.updateData(userCollectionData) { error in
            if let error = error {
                print("Error setting competition reference for current user: \(error)")
                return
            }
        }
        
        // setting data in challenged users account
        challengedUserCompRef.updateData(userCollectionData) { error in
            if let error = error {
                print("Error setting competition reference for challenged user: \(error)")
                return
            }
        }
        
        // setting data in competition collection
        competionCollectionRef.setData(compCollectionData) { error in
            if let error = error {
                print("Error setting ccoompetion \(error)")
                return
            }
            
            
            print("Chat created successfully.")
            // CALL ISABEL NOTIFICATION
            // pop the screen
        }
    }
    
    func showInvalidStepsAlert() {
        let alert = UIAlertController(title: "Invalid Steps!", message: "Please type in a valid amount", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func showUserInCompetitionAlert() {
        let alert = UIAlertController(title: "Choose Another Friend!", message: "This friend is already in a competition!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func showSelectFriendFirstAlert() {
        let alert = UIAlertController(title: "Choose Friend First!", message: "A friend must be chosen before starting a competition!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
}
