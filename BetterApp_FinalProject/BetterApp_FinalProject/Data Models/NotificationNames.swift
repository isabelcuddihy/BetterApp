 //
//  NotificationNames.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import Foundation
extension Notification.Name{
    
    static let NewChallangerSelected = Notification.Name("NewChallangerSelected")
    
    // notifies to refresh all notes table
    static let NewChatAdded = Notification.Name("NewChatAdded") // notifies to refresh all notes table
    
    // notification to send to Isabel's controller the CompID
    static let NewChallenge = Notification.Name("NewChallenge")
     
}
