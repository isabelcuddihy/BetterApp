//
//  CurrentChallengeViewController.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth
import HealthKit


class CurrentChallengeViewController: UIViewController {
    
    //init first screen
    let currentChallengeScreen = CurrentChallengeView()
    let notificationCenter = NotificationCenter.default        //init phone types and default
    var competitionID = "None"
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    let healthStore = HKHealthStore() // create healthsore instance to access data
    
    override func loadView() {
        view = currentChallengeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Current Challenge"
        
        // Request HealthKit Authorization
        requestHealthKitAuthorization()
        updateView()
        fetchStepsForLastDay()
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
    
    // ----- CONNECTION TO FIREBASE -----
    func updateView() {
        
        
        guard !self.competitionID.isEmpty else {
            print("Error: competitionID is empty.")
            return
        }
        
        var current_competition = Competition(competition_ID: "None", user: "", challenger: "", user_steps: 0,challenger_steps:0, challenge_status:false, challenge_date: Date(timeIntervalSince1970: 0), total_steps:0, number_of_days:0 )
        
        if let userEmail = currentUser?.email {
            // Access the document
            let docRef = self.database.collection("competitions").document(competitionID)
            
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
                
                // Access the competition field from the document
                let competitionData = documentSnapshot
                
                
                
                // Determine the recipient is user or not
                if let user1 = competitionData?.get("user1") as? String, user1 == self.currentUser?.displayName {
                    current_competition.user = user1
                    
                    current_competition.challenger = competitionData?.get("user2") as! String
                    
                    current_competition.challenger_steps = competitionData?.get("user2_steps") as! Int
                    current_competition.user_steps = competitionData?.get("user1_steps") as! Int
                    if let timestamp = competitionData?.get("start_time") as? Timestamp {
                        current_competition.challenge_date = timestamp.dateValue()
                    } else {
                        print("Error: start_time is not a valid Timestamp")
                    }
                    current_competition.total_steps = competitionData?.get("number_of_steps") as! Int
                    current_competition.number_of_days = competitionData?.get("number_of_days") as! Int
                    
                    
                } else if let user2 = competitionData?.get("user2") as? String {
                    current_competition.user = user2
                    
                    current_competition.challenger = competitionData?.get("user1")as! String
                    
                    current_competition.challenger_steps = competitionData?.get("user1_steps") as! Int
                    current_competition.user_steps = competitionData?.get("user2_steps") as! Int
                    if let timestamp = competitionData?.get("start_time") as? Timestamp {
                        current_competition.challenge_date = timestamp.dateValue()
                    } else {
                        print("Error: start_time is not a valid Firebase Timestamp")
                    }
                    current_competition.total_steps = competitionData?.get("number_of_steps") as! Int
                    current_competition.number_of_days = competitionData?.get("number_of_days") as! Int
                    
                    
                    
                }
                self.currentChallengeScreen.labelUserName.text = current_competition.user
                self.currentChallengeScreen.labelChallengerName.text = current_competition.challenger
                self.currentChallengeScreen.labelDaysLeft.text = String("Days Left: \(current_competition.number_of_days)")
                self.currentChallengeScreen.labelChallengerStepScore.text = String("Total Steps: \(current_competition.challenger_steps)")
                self.currentChallengeScreen.labelUserStepScore.text = String("Total Steps: \(current_competition.user_steps)")
                
                self.currentChallengeScreen.labelTotalStepsLeftForToday.text = String("Steps Left: \(current_competition.total_steps - current_competition.user_steps)")
                if current_competition.total_steps - current_competition.user_steps <= 0{
                    self.currentChallengeScreen.labelMetDailyGoal.text = "GOAL MET, CONGRATS!"
                }
                else {self.currentChallengeScreen.labelMetDailyGoal.text = "KEEP GOING!"
                    
                }
                
            }
        }
    }
    
    
    
    
    // ---------   HEALTHKIT SYNC - TO SYNC STEPS OF USER FOR CHALLENGE ----------
    
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
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchStepsForLastDay() {
        // Get the step count type
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
                
                // Add newly fetched steps to Firebase and update screen
                let docRef = self.database.collection("competitions").document(self.competitionID)
                
                docRef.getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error getting document: \(error)")
                        return
                    }
                    
                    guard let document = documentSnapshot, document.exists else {
                        print("Document does not exist")
                        return
                    }
                    
                    if let competitionData = document.data() {
                        let totalStepsGoal = competitionData["number_of_steps"] as? Int ?? 0
                        // Identify the user and the challenger
                        let isUser1 = competitionData["user1"] as? String == self.currentUser?.displayName
                        let isUser2 = competitionData["user2"] as? String == self.currentUser?.displayName
                        
                        // Update steps for the correct user (user1 or user2)
                        if isUser1 {
                            let lastUpdatedSteps = competitionData["user1_last_update_of_steps"] as? Double ?? 0
                            var currentSteps = competitionData["user1_steps"] as? Int ?? 0
                            if steps > lastUpdatedSteps {
                                currentSteps += Int(steps - lastUpdatedSteps)
                            }
                            else{
                                print("No new steps to add")
                            }
                            // Update user1 steps
                            docRef.updateData(["user1_steps": currentSteps, "user1_last_update_of_steps": steps]) { error in
                                if let error = error {
                                    print("Error updating steps: \(error.localizedDescription)")
                                } else {
                                    print("Steps updated successfully for user1.")
                                }
                            }
                            
                            // Update labels for user1
                            DispatchQueue.main.async {
                                self.currentChallengeScreen.labelUserStepScore.text = "Total Steps: \(currentSteps)"
                                self.currentChallengeScreen.labelTotalStepsLeftForToday.text = "Steps Left: \(totalStepsGoal - currentSteps)"
                            }
                            
                        } else if isUser2 {
                            let lastUpdatedSteps = competitionData["user2_last_update_of_steps"] as? Double ?? 0
                            var currentSteps = competitionData["user2_steps"] as? Int ?? 0
                            if steps > lastUpdatedSteps {
                                
                                currentSteps += Int(steps - lastUpdatedSteps)
                                
                                
                            }
                            else{
                                print("No new steps to add")
                            }
                            
                            // Update user2 steps
                            docRef.updateData(["user2_steps": currentSteps, "user2_last_update_of_steps": steps]) { error in
                                if let error = error {
                                    print("Error updating steps: \(error.localizedDescription)")
                                } else {
                                    print("Steps updated successfully for user2.")
                                }
                            }
                            
                            // Update labels for user2
                            DispatchQueue.main.async {
                                self.currentChallengeScreen.labelUserStepScore.text = "Total Steps: \(currentSteps)"
                                self.currentChallengeScreen.labelTotalStepsLeftForToday.text = "Steps Left: \(totalStepsGoal - currentSteps)"
                            }
                        }
                    }
                }
            } else {
                print("No steps data found for the last day.")
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // Update steps in Firebase
    private func updateStepsInFirebase(steps: Int) {
        guard !competitionID.isEmpty else {
            print("Error: competitionID is empty.")
            return
        }
        
        let docRef = database.collection("competitions").document(competitionID)
        
        docRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist")
                return
            }
            
            let competitionData = documentSnapshot
            
            if let user1 = competitionData?.get("user1") as? String, user1 == self.currentUser?.displayName {
                guard var currentSteps = competitionData?.get("user1_steps") as? Int else {
                    print("Error: user1_steps is nil or not an Int.")
                    return
                }
                currentSteps += steps
                docRef.updateData(["user1_steps": currentSteps]) { error in
                    if let error = error {
                        print("Error updating steps: \(error.localizedDescription)")
                    } else {
                        print("Steps updated successfully for user1.")
                    }
                }
            } else if let user2 = competitionData?.get("user2") as? String, user2 == self.currentUser?.displayName {
                guard var currentSteps = competitionData?.get("user2_steps") as? Int else {
                    print("Error: user2_steps is nil or not an Int.")
                    return
                }
                currentSteps += steps
                docRef.updateData(["user2_steps": currentSteps]) { error in
                    if let error = error {
                        print("Error updating steps: \(error.localizedDescription)")
                    } else {
                        print("Steps updated successfully for user2.")
                    }
                }
            }
        }
    }
}
