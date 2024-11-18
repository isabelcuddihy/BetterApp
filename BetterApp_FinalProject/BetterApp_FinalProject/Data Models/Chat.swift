//
//  Chat.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import Foundation
import FirebaseCore

struct Chat: Codable{
    var chatId: String
    var name: String
    var messageSent: String
    var timeStamp: Timestamp
    
    init(chatId: String, name: String, messageSent: String, timeStamp: Timestamp) {
        self.chatId = chatId
        self.name = name
        self.messageSent = messageSent
        self.timeStamp = timeStamp
    }
}
