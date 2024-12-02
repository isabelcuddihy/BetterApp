//
//  CreateChallengeController.swift
//  BetterApp_FinalProject
//
//  Created by Haidar Halawi on 11/21/24.
//

import UIKit

class CreateChallengeController: UIViewController {
    
    let createChallengeView = CreateChallengeView()
    
    //MARK: by default day selected (7)
    var selectedType = "7"
    
    let searchChatContactController = SearchBottomSheetController() // search bar for contacts
    var searchSheetNavController: UINavigationController!
    
    override func loadView() {
        view = createChallengeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:  adding menue to buttonSelectDays
        createChallengeView.buttonSelectDays.menu = getMenuTypes()
        
        createChallengeView.buttonChallenge.addTarget(self, action: #selector(onChallengeButtonTapped), for: .touchUpInside)
        
        
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
    



}
