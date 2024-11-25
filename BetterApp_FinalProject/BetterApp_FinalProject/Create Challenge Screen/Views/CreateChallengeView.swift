//
//  CreateChallengeView.swift
//  BetterApp_FinalProject
//
//  Created by Haidar Halawi on 11/21/24.
//

import UIKit

class CreateChallengeView: UIView {
    
    var labelCreateChallenge: UILabel!
    
    var buttonChooseFriend: UIButton!
    
    var labelDays: UILabel!
    
    var buttonSelectDays: UIButton!
    
    var labelSteps: UILabel!
    
    var textFieldSteps: UITextField!
    
    var buttonChallenge: UIButton!

        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        // New call functions -------------------------------------
        setupLabelCreateChallenge()
        
        setupButtonChooseFriend()

        setupLabelDays()
        
        setupButtonSelectDays()
        
        setupLabelSteps()
        
        setupTextFieldSteps()
        
        setupButtonChallenge()

        initConstraints()
    
    }
    
    func setupLabelCreateChallenge() {
        labelCreateChallenge = UILabel()
        labelCreateChallenge.text = "CREATE YOUR CHALLENGE"
        labelCreateChallenge.font = UIFont.boldSystemFont(ofSize: 26)
        labelCreateChallenge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCreateChallenge)
    }
    
    func setupButtonChooseFriend(){
        buttonChooseFriend = UIButton(type: .system)
        buttonChooseFriend.setTitle("Choose Friend", for: .normal)
        buttonChooseFriend.backgroundColor = UIColor.systemBlue
        buttonChooseFriend.setTitleColor(.white, for: .normal)
        buttonChooseFriend.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        buttonChooseFriend.layer.cornerRadius = 10
        buttonChooseFriend.clipsToBounds = true
        buttonChooseFriend.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // increase
        buttonChooseFriend.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonChooseFriend)
    }
    
    func setupLabelDays() {
        labelDays = UILabel()
        labelDays.text = "Days:"
        labelDays.font = UIFont.boldSystemFont(ofSize: 18)
        labelDays.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDays)
    }
    
    func setupButtonSelectDays(){
        buttonSelectDays = UIButton(type: .system)
        buttonSelectDays.setTitle("7", for: .normal)
        buttonSelectDays.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        buttonSelectDays.showsMenuAsPrimaryAction = true // MARK: Comeback and finish implementation of selecting different days
        buttonSelectDays.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSelectDays)
    }
    
    func setupLabelSteps() {
        labelSteps = UILabel()
        labelSteps.text = "Steps:"
        labelSteps.font = UIFont.boldSystemFont(ofSize: 18)
        labelSteps.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelSteps)
    }
    
    func setupTextFieldSteps() {
        textFieldSteps = UITextField()
        textFieldSteps.keyboardType = .emailAddress
        textFieldSteps.placeholder = "Type Steps Amount"
        textFieldSteps.borderStyle = .roundedRect
        textFieldSteps.font = .systemFont(ofSize: 18)
        textFieldSteps.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldSteps)
    }
    
    func setupButtonChallenge(){
        buttonChallenge = UIButton(type: .system)
        buttonChallenge.setTitle("Challenge", for: .normal)
        buttonChallenge.backgroundColor = UIColor.systemBlue
        buttonChallenge.setTitleColor(.white, for: .normal)
        buttonChallenge.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        buttonChallenge.layer.cornerRadius = 10
        buttonChallenge.clipsToBounds = true
        buttonChallenge.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // increase
        buttonChallenge.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonChallenge)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            labelCreateChallenge.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
            labelCreateChallenge.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            buttonChooseFriend.topAnchor.constraint(equalTo: labelCreateChallenge.bottomAnchor, constant: 36),
            buttonChooseFriend.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelDays.topAnchor.constraint(equalTo: buttonChooseFriend.bottomAnchor, constant: 24),
            labelDays.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 96),

            buttonSelectDays.topAnchor.constraint(equalTo: buttonChooseFriend.bottomAnchor, constant: 24),
            buttonSelectDays.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -96),
            
            labelSteps.topAnchor.constraint(equalTo: labelDays.bottomAnchor, constant: 36),
            labelSteps.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            textFieldSteps.topAnchor.constraint(equalTo: labelSteps.bottomAnchor, constant: 22),
            textFieldSteps.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 96),
            textFieldSteps.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -96),
            
            buttonChallenge.topAnchor.constraint(equalTo: textFieldSteps.bottomAnchor, constant: 36),
            buttonChallenge.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),

        ])
    }
    
    
    

    //MARK: unused methods...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
