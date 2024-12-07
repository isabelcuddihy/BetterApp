//
//  CurrentChallengeView.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import UIKit

class CurrentChallengeView: UIView {
    
    
    // Setup User
    var userProfilePic: UIImageView!
    var labelUserName: UILabel!
    var labelUserStepScore: UILabel!
    
    
    //Setup Challenger
    var challengerProfilePic: UIImageView!
    var labelChallengerName: UILabel!
    var labelChallengerStepScore: UILabel!
    
    
    
    //Current Challenge
    
    var labelDaysLeft: UILabel!
    var labelTotalStepsLeftForToday: UILabel!
    var labelBatteryTopper: UILabel!
    var labelMetDailyGoal:  UILabel!
    let labelWidth: CGFloat = 200
    let labelHeight: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        //Load User
        setupUserProfilePic()
        setupLabelUserName()
        setupLabelUserStepScore()
        
        //Load Challenger
        setupChallengerProfilePic()
        setupLabelChallengerName()
        setupLabelChallengerStepScore()
        
        
        // Load Challenge Rules
        setupBatteryTopper()
        setupLabelDaysLeft()
        setupLabelTotalStepsLeftForToday()
        setupLabelMetDailyGoal()
        
        initConstraints()
    }
    
    
    //MARK: initializing the UI elements...
    func setupUserProfilePic(){
        userProfilePic = UIImageView()
        userProfilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        userProfilePic.tintColor = .blue
        userProfilePic.contentMode = .scaleToFill
        userProfilePic.clipsToBounds = true
        userProfilePic.layer.masksToBounds = true
        userProfilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userProfilePic)
    }
    
    func setupChallengerProfilePic(){
        challengerProfilePic = UIImageView()
        challengerProfilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        challengerProfilePic.tintColor = .red
        challengerProfilePic.contentMode = .scaleToFill
        challengerProfilePic.clipsToBounds = true
        challengerProfilePic.layer.masksToBounds = true
        challengerProfilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(challengerProfilePic)
    }
    
    func setupLabelUserStepScore(){
        labelUserStepScore = UILabel()
        labelUserStepScore.font = .boldSystemFont(ofSize: 16)
        labelUserStepScore.text = "User Step Score: 0"
        labelUserStepScore.textColor = .blue
        labelUserStepScore.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelUserStepScore)
    }
    
    func setupLabelChallengerStepScore(){
        labelChallengerStepScore = UILabel()
        labelChallengerStepScore.font = .boldSystemFont(ofSize: 16)
        labelChallengerStepScore.text = "Challenger Step Score: 0"
        labelChallengerStepScore.textColor = .red
        labelChallengerStepScore.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelChallengerStepScore)
    }
    
    
    func setupLabelUserName(){
        labelUserName = UILabel()
        labelUserName.font = .boldSystemFont(ofSize: 20)
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        labelUserName.textColor = .blue
        labelUserName.text = "User Name"
        
        self.addSubview(labelUserName)
    }
    func setupLabelChallengerName(){
        labelChallengerName = UILabel()
        labelChallengerName.font = .boldSystemFont(ofSize: 20)
        labelChallengerName.translatesAutoresizingMaskIntoConstraints = false
        labelChallengerName.textColor = .red
        labelChallengerName.text = "Challenger Name"
        self.addSubview(labelChallengerName)
    }
    
    func setupBatteryTopper(){
        labelBatteryTopper = UILabel()
        labelBatteryTopper.backgroundColor = .systemGreen
        labelBatteryTopper.textAlignment = .center
        labelBatteryTopper.layer.cornerRadius = 8
        labelBatteryTopper.layer.masksToBounds = true
        labelBatteryTopper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelBatteryTopper)
    }
    func setupLabelDaysLeft() {
        labelDaysLeft = UILabel()
        labelDaysLeft.font = .boldSystemFont(ofSize: 16)
        labelDaysLeft.text = "Remaining Days: 0"
        labelDaysLeft.textColor = .black
        labelDaysLeft.backgroundColor = .systemGreen
        labelDaysLeft.textAlignment = .center
        labelDaysLeft.layer.cornerRadius = 8
        labelDaysLeft.layer.masksToBounds = true
        labelDaysLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDaysLeft)
    }

    func setupLabelTotalStepsLeftForToday() {
        labelTotalStepsLeftForToday = UILabel()
        labelTotalStepsLeftForToday.font = .boldSystemFont(ofSize: 16)
        labelTotalStepsLeftForToday.text = "Remaining Steps: 0"
        labelTotalStepsLeftForToday.textColor = .black
        labelTotalStepsLeftForToday.backgroundColor = .systemGreen
        labelTotalStepsLeftForToday.textAlignment = .center
        labelTotalStepsLeftForToday.layer.cornerRadius = 8
        labelTotalStepsLeftForToday.layer.masksToBounds = true
        labelTotalStepsLeftForToday.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTotalStepsLeftForToday)
    }

    func setupLabelMetDailyGoal() {
        labelMetDailyGoal = UILabel()
        labelMetDailyGoal.font = .boldSystemFont(ofSize: 16)
        labelMetDailyGoal.text = "KEEP GOING!" // change to GOAL MET when you reach the step count
        labelMetDailyGoal.textColor = .black
        labelMetDailyGoal.backgroundColor = .systemGreen
        labelMetDailyGoal.textAlignment = .center
        labelMetDailyGoal.layer.cornerRadius = 8
        labelMetDailyGoal.layer.masksToBounds = true
        labelMetDailyGoal.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelMetDailyGoal)
    }

    
    //MARK: setting up constraints...
    func initConstraints() {
        

        NSLayoutConstraint.activate([
            // User profile constraints
            userProfilePic.widthAnchor.constraint(equalToConstant: 32),
            userProfilePic.heightAnchor.constraint(equalToConstant: 32),
            userProfilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            userProfilePic.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -80),
            
            challengerProfilePic.widthAnchor.constraint(equalToConstant: 32),
            challengerProfilePic.heightAnchor.constraint(equalToConstant: 32),
            challengerProfilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            challengerProfilePic.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 80),
            
            labelUserName.topAnchor.constraint(equalTo: userProfilePic.bottomAnchor, constant: 8),
            labelUserName.centerXAnchor.constraint(equalTo: userProfilePic.centerXAnchor),
            
            labelChallengerName.topAnchor.constraint(equalTo: challengerProfilePic.bottomAnchor, constant: 8),
            labelChallengerName.centerXAnchor.constraint(equalTo: challengerProfilePic.centerXAnchor),
            
            labelUserStepScore.topAnchor.constraint(equalTo: labelUserName.bottomAnchor, constant: 16),
            labelUserStepScore.centerXAnchor.constraint(equalTo: labelUserName.centerXAnchor),
            
            labelChallengerStepScore.topAnchor.constraint(equalTo: labelChallengerName.bottomAnchor, constant: 16),
            labelChallengerStepScore.centerXAnchor.constraint(equalTo: labelChallengerName.centerXAnchor),
           
            // Challenge rules
            
            labelBatteryTopper.topAnchor.constraint(equalTo: labelChallengerStepScore.bottomAnchor, constant: 50),
            labelBatteryTopper.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelBatteryTopper.widthAnchor.constraint(equalToConstant: 80),
            labelBatteryTopper.heightAnchor.constraint(equalToConstant: 60),
            
            
            labelDaysLeft.topAnchor.constraint(equalTo: labelBatteryTopper.bottomAnchor, constant: 16),
            labelDaysLeft.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelDaysLeft.widthAnchor.constraint(equalToConstant: labelWidth),
            labelDaysLeft.heightAnchor.constraint(equalToConstant: labelHeight),

            labelTotalStepsLeftForToday.topAnchor.constraint(equalTo: labelDaysLeft.bottomAnchor, constant: 16),
            labelTotalStepsLeftForToday.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTotalStepsLeftForToday.widthAnchor.constraint(equalToConstant: labelWidth),
            labelTotalStepsLeftForToday.heightAnchor.constraint(equalToConstant: labelHeight),

            labelMetDailyGoal.topAnchor.constraint(equalTo: labelTotalStepsLeftForToday.bottomAnchor, constant: 16),
            labelMetDailyGoal.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelMetDailyGoal.widthAnchor.constraint(equalToConstant: labelWidth),
            labelMetDailyGoal.heightAnchor.constraint(equalToConstant: labelHeight),
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

