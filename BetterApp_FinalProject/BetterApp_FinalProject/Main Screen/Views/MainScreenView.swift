//
//  MainScreenView.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
// TD: Convert this main screen to the main user profile page for better app
// Note the personal details info can either be simple UI labels or we can convert it to the tableView from ChatsTableView. First ill try the simple UI labels and also reach out to group on which is better


import UIKit


class MainScreenView: UIView {
    // 11/24 - Adding in UI elements for Better App Main Screen. Soni
    

    // Email Label
    //var labelEmail: UILabel! TD: safe delete when verify not needed
    // Competition_ID Label
    var labelCompetitionID: UILabel!
    // Wins Label
    var labelWins: UILabel!
    // Losses Label
    var labelLosses: UILabel!
    
    var profilePic: UIImageView!
    var labelText: UILabel!
    var floatingButtonAddChat: UIButton!
    var tableViewChats: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        // 11/24 - Adding in UI elements for Better App Main Screen. Soni
        //setupLabelEmail()
        setupLabelCompetitionID()
        setupLabelWins()
        setupLabelLosses()
        setupFloatingButtonAddChat()
        setupTableViewChats()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
//    func setupLabelEmail(){ TD: safe delete when verify not needed
//        labelEmail = UILabel()
//        labelEmail.text = "Email: soni@test.com" //dummy text data
//        labelEmail.font = .boldSystemFont(ofSize: 14)
//        labelEmail.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(labelEmail)
//    }
    
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
    
    func setupTableViewChats(){
        tableViewChats = UITableView()
        tableViewChats.register(ChatTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChats)
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
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            
            // 11/24 - Adding in UI elements for Better App Main Screen. Soni
            // Competition ID Label
           labelCompetitionID.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 16),
           labelCompetitionID.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
           labelCompetitionID.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

           // Wins Label
           labelWins.topAnchor.constraint(equalTo: labelCompetitionID.bottomAnchor, constant: 8),
           labelWins.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
           labelWins.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

           // Losses Label
           labelLosses.topAnchor.constraint(equalTo: labelWins.bottomAnchor, constant: 8),
           labelLosses.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
           labelLosses.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableViewChats.topAnchor.constraint(equalTo: labelLosses.bottomAnchor, constant: 8),
            tableViewChats.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewChats.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChats.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
