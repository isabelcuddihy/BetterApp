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
    
    override func loadView() {
        view = createChallengeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:  adding menue to buttonSelectDays
        createChallengeView.buttonSelectDays.menu = getMenuTypes()
    }
    
//    @objc func onAddChatButtonTapped(){
//        setupSearchBottomSheet()
//        
//        present(searchSheetNavController, animated: true)
//    }
    
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
    

    



}
