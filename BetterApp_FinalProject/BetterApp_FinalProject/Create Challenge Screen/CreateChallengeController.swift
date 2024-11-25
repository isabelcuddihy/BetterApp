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
        
        // functionality for selecting days durration for challenge
//        createChallengeView.buttonChooseFriend.addTarget(self, action: #selector(onAddChatButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
//    @objc func onAddChatButtonTapped(){
//        setupSearchBottomSheet()
//        
//        present(searchSheetNavController, animated: true)
//    }
    

    



}
