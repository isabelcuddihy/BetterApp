//
//  ChatView.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import UIKit

class ChatView: UIView {


        var profilePic: UIImageView!
        var labelUserName: UILabel!
        var tableViewChats: UITableView!
//        var textFieldNewMessage: UITextField! //MARK: removed incase UITextView is better -Haidar 11/12
    
        //MARK: bottom view for sending a message on ChatView -Haidar changes 11/12
        var bottomAddView:UIView!
        var textViewNewMessageBox: UITextView!
        var buttonSend:UIButton!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .white
            
            setupProfilePic()
            setupLabelUserName()
          
            setupTableViewChats()
            
            //MARK: setup functions for bottom view -Haidar 11/12
            setupBottomAddView()
            setupTextViewNewMessageBox()
            setupButtonSend()
            
            initConstraints()
        }
    
    //MARK: the table view to show the list of contacts...
    func setupTableViewChats(){
        tableViewChats = UITableView()
        tableViewChats.register(IndividualChatTableViewCell.self, forCellReuseIdentifier: "message")
        tableViewChats.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChats)
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
        
    func setupLabelUserName(){
        labelUserName = UILabel()
        labelUserName.font = .boldSystemFont(ofSize: 14)
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelUserName)
    }
   

    
    func setupBottomAddView(){
        bottomAddView = UIView()
        bottomAddView.backgroundColor = .white
        bottomAddView.layer.cornerRadius = 6
        bottomAddView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomAddView.layer.shadowOffset = .zero
        bottomAddView.layer.shadowRadius = 4.0
        bottomAddView.layer.shadowOpacity = 0.7
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }

    func setupTextViewNewMessageBox() {
        textViewNewMessageBox = UITextView()
        textViewNewMessageBox.layer.borderColor = UIColor.lightGray.cgColor
        textViewNewMessageBox.layer.borderWidth = 1
        textViewNewMessageBox.layer.cornerRadius = 6
        textViewNewMessageBox.font = UIFont.systemFont(ofSize: 16)
        textViewNewMessageBox.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(textViewNewMessageBox)
    }
    
    func setupButtonSend(){
        buttonSend = UIButton(type: .system)
        buttonSend.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonSend.setTitle("Send Message", for: .normal)
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        bottomAddView.addSubview(buttonSend)
    }
    
        //MARK: setting up constraints...
        func initConstraints(){
            NSLayoutConstraint.activate([
                profilePic.widthAnchor.constraint(equalToConstant: 32),
                profilePic.heightAnchor.constraint(equalToConstant: 32),
                profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
                profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                
                labelUserName.topAnchor.constraint(equalTo: profilePic.bottomAnchor),
                labelUserName.leadingAnchor.constraint(equalTo: profilePic.leadingAnchor, constant: 8),
                labelUserName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                
                tableViewChats.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 32),
                tableViewChats.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                tableViewChats.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                tableViewChats.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: -8),
                
                // Bottom add view
                bottomAddView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                bottomAddView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                bottomAddView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                
                // New text box constraints
                textViewNewMessageBox.topAnchor.constraint(equalTo: bottomAddView.topAnchor, constant: 8),
                textViewNewMessageBox.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 8),
                textViewNewMessageBox.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -8),
                textViewNewMessageBox.heightAnchor.constraint(equalToConstant: 100),  // Adjust height as needed
                
                buttonSend.topAnchor.constraint(equalTo: textViewNewMessageBox.bottomAnchor, constant: 8),
                buttonSend.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 4),
                buttonSend.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -4),
                buttonSend.bottomAnchor.constraint(equalTo: bottomAddView.bottomAnchor, constant: -8),
            
           
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

