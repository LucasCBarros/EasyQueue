//
//  Note.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 23/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class Note: Equatable {
    
    let noteID: String
    let noteText: String
    let userID: String
    let date: Date
    
    init(json: [String: Any]) {
        self.noteID = json["noteID"] as? String ?? "?"
        self.noteText = json["noteText"] as? String ?? "??"
        self.userID = json["userID"] as? String ?? "???"
        
        //Tirar o timestamp e colocar a data e hora
        let timeInterval = Double.init(self.noteID)
        self.date = Date(timeIntervalSince1970: timeInterval! / 1000)
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.noteID == rhs.noteID
    }
    
}
