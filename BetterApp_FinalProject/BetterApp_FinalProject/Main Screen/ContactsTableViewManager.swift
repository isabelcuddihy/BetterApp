//
//  ContactsTableViewManager.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import Foundation
import UIKit
import FirebaseAuth

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewContactsID", for: indexPath) as! ChatTableViewCell
       
        cell.labelConversationName.text = chatsList[indexPath.row].name
        
        cell.labelName.text = "Sender: \(chatsList[indexPath.row].name)"
        cell.labelMessageSent.text = "Message: \(chatsList[indexPath.row].messageSent)"
        cell.labelTimeStamp.text = "Timestamp: \(convertTimestampToString(timestamp: chatsList[indexPath.row].timeStamp))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChat = chatsList[indexPath.row]
        
        let chatViewController = ChatViewController()
        chatViewController.messagingContact = selectedChat.name
        chatViewController.chatID = selectedChat.chatId
                    
        // Navigate to ChatViewController
        self.navigationController?.pushViewController(chatViewController, animated: true)
                }
                
            }
            
            // extention added -Haidar 11/12
            
            
        
 
