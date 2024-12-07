//
//  Contact.swift
//  BetterApp_FinalProject
//
//  Created by Isabel Cuddihy on 11/18/24.
//

import Foundation
import FirebaseFirestore

struct Contact: Codable{
  //  @DocumentID var id: String?
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
