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
        
        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onChooseFriendButtonTapped), for: .touchUpInside)
        
        // Request authorization when the view loads
        //requestHealthKitAuthorization()
        
        print("this statement is printed after view is loaded")
//        
//        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onChooseFriendButtonTapped), for: .touchUpInside)
//        onChallengeButtonTapped
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
    
   
}
