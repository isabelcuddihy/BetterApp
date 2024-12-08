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
    // init screen
    let currentChallengeScreen = CurrentChallengeView()
    
    //init notification center
    let notificationCenter = NotificationCenter.default
    
    // default competition ID == "None" -> should be updated during push to this screen
    var competitionID = "None"
    
    //connecting to Firesbase and Firestore
    let database = Firestore.firestore()
    
    //Login Authorization for User
    let currentUser = Auth.auth().currentUser
    
    // create healthsore instance to access data
    let healthStore = HKHealthStore()
    
    //Start and end dates for Competition
    let calendar = Calendar.current
    var start_date: Date?
    var end_date: Date?
    
    //Load Screen View
    override func loadView() {
        view = currentChallengeScreen
    }
    
    //Screen successfully loaded-> add specifics to elements
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Current Challenge"
        
        // Request HealthKit Authorization
        requestHealthKitAuthorization()
        
        //update view with specific competition information
        updateView()
        
      
       
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
        
        // Doube check competition ID exist
        guard !self.competitionID.isEmpty else {
            print("Error: competitionID is empty.")
            return
        }
        
        // Set up Competition instance to hold all data for current competition
        var current_competition = Competition(competition_ID: "None", user: "", challenger: "", user_steps: 0,challenger_steps:0, challenge_status:false, challenge_date: Date(timeIntervalSince1970: 0), total_steps:0, number_of_days:0 )
        
        // select user account within firestore
        if let userEmail = currentUser?.email {
            
            // Access the document matching the provided competition ID
            let docRef = self.database.collection("competitions").document(competitionID)
            
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
                
                // Access the competition information from the document
                let competitionData = documentSnapshot
                
                
                
                // Determine the which user (1 or 2) the current user is registered as -> the other user will be labelled as the "challenger"
                if let user1 = competitionData?.get("user1") as? String, user1 == self.currentUser?.displayName {
                    
                    // Get user's information for competition
                    current_competition.user = user1
                    current_competition.user_steps = competitionData?.get("user1_steps") as! Int
                    
                    // Get challengers information
                    current_competition.challenger = competitionData?.get("user2") as! String
                    current_competition.challenger_steps = competitionData?.get("user2_steps") as! Int
                    
                    // get rules for competition
                    current_competition.total_steps = competitionData?.get("number_of_steps") as! Int
                    current_competition.number_of_days = competitionData?.get("number_of_days") as! Int
                    
                    // Get start time for competition -> determines how many days are left in competition
                    if let timestamp = competitionData?.get("start_time") as? Timestamp {
                        current_competition.challenge_date = timestamp.dateValue()
                        self.start_date = timestamp.dateValue()
                          
                          // Ensure start_date is not nil before proceeding
                          if let startDate = self.start_date {
                              // Add the competition length (number of days) to the start date
                              if let calculatedEndDate = self.calendar.date(byAdding: .day, value: current_competition.number_of_days, to: startDate) {
                                  self.end_date = calculatedEndDate
                                  print("Start Date: \(self.start_date)" ?? "EMPTY")
                                  print("End Date: \(self.end_date)" ?? "EMPTY")
                              } else {
                                  print("Failed to calculate end date.")
                              }
                          } else {
                              print("Start date is nil.")
                          }
                    } else {
                        print("Error: start_time is not a valid Timestamp")
                    }
                    
                   
                    
                    
                } else if let user2 = competitionData?.get("user2") as? String {
                    // Get user's information for competition
                    current_competition.user = user2
                    current_competition.user_steps = competitionData?.get("user2_steps") as! Int
                    
                    // Get challengers information
                    current_competition.challenger = competitionData?.get("user1")as! String
                    current_competition.challenger_steps = competitionData?.get("user1_steps") as! Int
                    
                    // Get start time for competition -> determines how many days are left in competition
                    if let timestamp = competitionData?.get("start_time") as? Timestamp {
                        current_competition.challenge_date = timestamp.dateValue()
                        print("Start time: \(timestamp.dateValue())")
                        self.start_date = timestamp.dateValue()
                        self.end_date = timestamp.dateValue() + TimeInterval(current_competition.number_of_days * 86400)
                  

                    } else {
                        print("Error: start_time is not a valid Firebase Timestamp")
                    }
                    
                    // get rules for competition
                    current_competition.total_steps = competitionData?.get("number_of_steps") as! Int
                    current_competition.number_of_days = competitionData?.get("number_of_days") as! Int
                    
                    
                    
                }
                
                // Update all labels on screen with specific competition data
                self.currentChallengeScreen.labelUserName.text = current_competition.user
                self.currentChallengeScreen.labelChallengerName.text = current_competition.challenger
                self.currentChallengeScreen.labelChallengerStepScore.text = String("Total Steps: \(current_competition.challenger_steps)")
                self.currentChallengeScreen.labelUserStepScore.text = String("Total Steps: \(current_competition.user_steps)")
                
                // update remaining number of steps
                self.currentChallengeScreen.labelTotalStepsLeftForToday.text = String("Steps Left: \(current_competition.total_steps - current_competition.user_steps)")
                
                // determines how many days are left in the competition
                self.currentChallengeScreen.labelDaysLeft.text = String("Days Left: \(self.how_many_days_left())")
                
                // determines if user has met step goal for competition
                if current_competition.total_steps - current_competition.user_steps <= 0{
                    self.currentChallengeScreen.labelMetDailyGoal.text = "GOAL MET, CONGRATS!"
                    self.currentChallengeScreen.labelMetDailyGoal.backgroundColor = .green
                }
                else {self.currentChallengeScreen.labelMetDailyGoal.text = "KEEP GOING!"
                    
                }
                self.fetchStepsForLastDay()
                
            }
        }
    }
    // determines how many days are left in the competition
    func how_many_days_left()-> String{
       
        if let endDate = self.end_date, let startDate = self.start_date {
            let currentDate = Date()
            
            // Calculate the remaining time interval in seconds from current time to end date of competition
            let remainingTimeInterval = endDate.timeIntervalSince(currentDate)
            
            // Convert remaining time interval into days
            let daysRemaining = max(Int(remainingTimeInterval / (24 * 3600)), 0)
            
            return "\(daysRemaining)"
        } else {
            print("Start or End date is nil. Cannot calculate days remaining.")
            self.currentChallengeScreen.labelDaysLeft.text = "Days Left: N/A"
        }
        return "ALL DONE!"
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
        
       
        
        // grabbing date from date range
        let predicate = HKQuery.predicateForSamples(withStart: self.start_date, end: self.end_date, options: .strictStartDate)
        print(self.start_date, self.end_date)
        //query the step statistic from HealthKit
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Error fetching steps: \(error.localizedDescription)")
                return
            }
            
            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                print("Steps from HealthKit: \(steps)")

                       // Validate step count (filter unrealistic values)
                       if steps > 100000 { // Set a realistic threshold for daily steps
                           print("Warning: Step count exceeds realistic range. Value: \(steps)")
                           return
                       }
                
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
                                print("Steps from HealthKit: \(steps)")
                                print("Last Updated Steps from Firebase: \(lastUpdatedSteps)")
                                print("Steps to Add: \(steps - lastUpdatedSteps)")
                                print("Current Steps: \(currentSteps)")
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
                                print("Steps from HealthKit: \(steps)")
                                print("Last Updated Steps from Firebase: \(lastUpdatedSteps)")
                                print("Steps to Add: \(steps - lastUpdatedSteps)")
                                print("Current Steps: \(currentSteps)")
                                
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
