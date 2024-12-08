//
//  MainScreenView.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.


import UIKit


class MainScreenView: UIView {
    // 11/24 - Adding in UI elements for Better App Main Screen. Soni
    var labelCompetitionID: UILabel!
    var labelWins: UILabel!
    var labelLosses: UILabel!
    var labelPersonalDetails: UILabel!
    var profilePic: UIImageView!
    var labelText: UILabel!
    var buttonCompetition: UIButton!
    var detailsContainerView: UIView! // UI element for details container
    var stackView : UIStackView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupLabelWins()
        setupLabelLosses()

        setupButtonCompetition()
       
        initConstraints()
    }
    


    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        // Default Symbol is Green
        profilePic.tintColor = .green
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.text = "Welcome"
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.textColor = .black
        labelText.isHidden = false
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupLabelWins(){
        labelWins = UILabel()
        //Text
        labelWins.text = "Wins: 0 "
        labelWins.font = .boldSystemFont(ofSize: 14)
        labelWins.textColor = .black
        labelWins.textAlignment = .center
        
        //background color
        labelWins.backgroundColor = .green
        
        //Rounded Corners
        labelWins.layer.cornerRadius = 16
        
        //Borders
        labelWins.layer.borderColor = UIColor.darkGray.cgColor
        labelWins.layer.borderWidth = 2
        
        //Keep to same size
        labelWins.layer.masksToBounds = true
        
        //Hide until user is logged in
        labelWins.isHidden = true
        
        labelWins.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelWins)
    }
    
    func setupLabelLosses(){
        labelLosses = UILabel()
        //text
        labelLosses.text = "Losses: 0"
        labelLosses.font = .boldSystemFont(ofSize: 14)
        labelLosses.textColor = .black
        labelLosses.textAlignment = .center
        
        //background color
        labelLosses.backgroundColor = .green
        
        //Rounded corners
        labelLosses.layer.cornerRadius = 16
        
        //Border
        labelLosses.layer.borderColor = UIColor.darkGray.cgColor
        labelLosses.layer.borderWidth = 2
        
        //Keep to proper size
        labelLosses.layer.masksToBounds = true
        
        //Hide until user is logged in
        labelLosses.isHidden = true
        labelLosses.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelLosses)
    }
    
    
    func setupButtonCompetition(){
        buttonCompetition = UIButton(type: .system)
        //text for button
        buttonCompetition.setTitle("Create Challenge", for: .normal)
        buttonCompetition.contentVerticalAlignment = .center
        buttonCompetition.contentHorizontalAlignment = .center
        buttonCompetition.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonCompetition.setTitleColor(UIColor.black, for: .normal)
        //image on button
        buttonCompetition.setImage(UIImage(systemName: "bolt.heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonCompetition.tintColor = .white
        buttonCompetition.imageView?.contentMode = .scaleAspectFit
        buttonCompetition.imageView?.layer.shadowOffset = .zero
        buttonCompetition.imageView?.layer.shadowRadius = 1
        buttonCompetition.imageView?.layer.shadowOpacity = 1
        buttonCompetition.imageView?.clipsToBounds = true
        
        //Button background and border
        buttonCompetition.layer.cornerRadius = 16
        buttonCompetition.backgroundColor = .systemRed
        buttonCompetition.layer.borderColor = UIColor.darkGray.cgColor
        buttonCompetition.layer.borderWidth = 2
        
        buttonCompetition.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCompetition)
    }
    
  
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            labelText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
       
            
            profilePic.widthAnchor.constraint(equalToConstant: 100),
            profilePic.heightAnchor.constraint(equalToConstant: 100),
            profilePic.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),

            
            labelWins.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 16),
            labelWins.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor),
            labelWins.widthAnchor.constraint(equalToConstant: 200),
            labelWins.heightAnchor.constraint(equalToConstant: 80),
            
            labelLosses.topAnchor.constraint(equalTo: labelWins.bottomAnchor, constant: 16),
            labelLosses.centerXAnchor.constraint(equalTo: labelWins.centerXAnchor),
            labelLosses.widthAnchor.constraint(equalToConstant: 200),
            labelLosses.heightAnchor.constraint(equalToConstant: 80),
            
         
            // Floating Action Button
            buttonCompetition.widthAnchor.constraint(equalToConstant: 200),
            buttonCompetition.heightAnchor.constraint(equalToConstant: 80),
            buttonCompetition.topAnchor.constraint(equalTo: labelLosses.bottomAnchor, constant: 16),
            buttonCompetition.centerXAnchor.constraint(equalTo: labelLosses.centerXAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
