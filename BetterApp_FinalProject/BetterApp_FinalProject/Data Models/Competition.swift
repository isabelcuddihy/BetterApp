//
//  Chat.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
// This can replace competition: how long it is, steps, who are participating, timestamp for when it started 

import Foundation
import FirebaseCore

struct Competition: Codable{
    var competition_ID: String
    var user: String
    var challenger: String
    var user_steps: Int
    var challenger_steps: Int
    var user1_last_update_of_steps: Int
    var challenger_last_update_of_steps: Int
    var challenge_status: Bool
    var challenge_date: Date
    var total_steps: Int
    var number_of_days: Int
    
    
    init(competition_ID: String, user: String, challenger: String, user_steps: Int,challenger_steps:Int, challenge_status:Bool, challenge_date:Date, total_steps:Int, number_of_days:Int ) {
        self.competition_ID = competition_ID
        self.user = user
        self.challenger = challenger
        self.user_steps = user_steps
        self.challenger_steps = challenger_steps
        self.challenge_status = challenge_status
        self.challenge_date = challenge_date
        self.total_steps = total_steps
        self.number_of_days = number_of_days
        self.challenger_last_update_of_steps = 0
        self.user1_last_update_of_steps = 0
    }
}
