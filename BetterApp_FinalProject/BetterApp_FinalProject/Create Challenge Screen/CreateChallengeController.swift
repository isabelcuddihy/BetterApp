//
//  CreateChallengeController.swift
//  BetterApp_FinalProject
//
//  Created by Haidar Halawi on 11/21/24.
//

import UIKit
import HealthKit // import healthkit

class CreateChallengeController: UIViewController {
    
    let createChallengeView = CreateChallengeView()
    
    //MARK: by default day selected (7)
    var selectedType = "7"
    
    let searchChatContactController = SearchBottomSheetController() // search bar for contacts
    var searchSheetNavController: UINavigationController!
    
    let healthStore = HKHealthStore() // create healthsore instance to access data
    
    override func loadView() {
        view = createChallengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:  adding menue to buttonSelectDays
        createChallengeView.buttonSelectDays.menu = getMenuTypes()
        
        createChallengeView.buttonChallenge.addTarget(self, action: #selector(onChallengeButtonTapped), for: .touchUpInside)
        
        // Request authorization when the view loads
        requestHealthKitAuthorization()
        
        print("this statement is printed after view is loaded")
//
//        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onChooseFriendButtonTapped), for: .touchUpInside)
//
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
    
    @objc func onChallengeButtonTapped(){
        setupSearchBottomSheet()
        
        present(searchSheetNavController, animated: true)
    }
    
//    @objc func onChooseFriendButtonTapped(){
//        requestHealthKitAuthorization() // created this function to force steps data from health kit. trying to figure out where its being printed
//        print("onChooseFriendButtonTapped")
//    }
    
    
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
}
