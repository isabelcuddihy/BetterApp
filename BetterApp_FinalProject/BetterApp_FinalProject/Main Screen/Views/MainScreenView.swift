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
    var floatingButtonAddChat: UIButton!
    var detailsContainerView: UIView! // UI element for details container
    var stackView : UIStackView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        // 11/24 - Adding in UI elements for Better App Main Screen. Soni
        setupLabelCompetitionID()
        setupLabelWins()
        setupLabelLosses()
        setupLabelPersonalDetails()
        setupFloatingButtonAddChat()
        setupDetailsContainerView()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        // Changing it to green
        profilePic.tintColor = .systemGreen
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupDetailsContainerView() {
        // Creating the container view for personal details
        detailsContainerView = UIView()
        detailsContainerView.backgroundColor = .green
        detailsContainerView.layer.masksToBounds = true
        // Round the corners
        detailsContainerView.layer.cornerRadius = 18
        detailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsContainerView)

        
        // Creating the stack view to hold the labels
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        detailsContainerView.addSubview(stackView)
    
        
        // Add the labels to the stack view
        stackView.addArrangedSubview(labelPersonalDetails)
        stackView.addArrangedSubview(labelCompetitionID)
        stackView.addArrangedSubview(labelWins)
        stackView.addArrangedSubview(labelLosses)

        // Set constraints for details container view and stack view
        NSLayoutConstraint.activate([
            // Details container constraints (size and position)
            detailsContainerView.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 20),
            detailsContainerView.widthAnchor.constraint(equalToConstant: 50),
            detailsContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailsContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Stack View Constraints (padding and centering)
            stackView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: -8),
        ])
          
    }
    
 
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupLabelPersonalDetails(){
        labelPersonalDetails = UILabel()
        labelPersonalDetails.text = "Personal Details"
        labelPersonalDetails.font = .boldSystemFont(ofSize: 18)
        labelPersonalDetails.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPersonalDetails)
    }

    
    func setupLabelCompetitionID(){
        labelCompetitionID = UILabel()
        labelCompetitionID.text = "Current Competition: User1VSUser2" //dummy text data
        labelCompetitionID.font = .boldSystemFont(ofSize: 14)
        labelCompetitionID.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCompetitionID)
    }
    
    func setupLabelWins(){
        labelWins = UILabel()
        labelWins.text = "Wins: 5" //dummy text data
        labelWins.font = .boldSystemFont(ofSize: 14)
        labelWins.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelWins)
    }
    
    func setupLabelLosses(){
        labelLosses = UILabel()
        labelLosses.text = "Losses: 0" //dummy text data
        labelLosses.font = .boldSystemFont(ofSize: 14)
        labelLosses.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelLosses)
    }
    
    
    func setupFloatingButtonAddChat(){
        floatingButtonAddChat = UIButton(type: .system)
        floatingButtonAddChat.setTitle("", for: .normal)
        floatingButtonAddChat.setImage(UIImage(systemName: "plus.message.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonAddChat.contentHorizontalAlignment = .fill
        floatingButtonAddChat.contentVerticalAlignment = .fill
        floatingButtonAddChat.imageView?.contentMode = .scaleAspectFit
        floatingButtonAddChat.layer.cornerRadius = 16
        floatingButtonAddChat.imageView?.layer.shadowOffset = .zero
        floatingButtonAddChat.imageView?.layer.shadowRadius = 0.8
        floatingButtonAddChat.imageView?.layer.shadowOpacity = 0.7
        floatingButtonAddChat.imageView?.clipsToBounds = true
        floatingButtonAddChat.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonAddChat)
    }
    
  
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            profilePic.widthAnchor.constraint(equalToConstant: 100),
            profilePic.heightAnchor.constraint(equalToConstant: 100),
            profilePic.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor, constant: -20),
            labelText.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor),
            
            
            // Details container
            detailsContainerView.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 20),
            detailsContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailsContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            
            // Floating Action Button
            floatingButtonAddChat.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonAddChat.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonAddChat.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonAddChat.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
