//
//  Formatter.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 30/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class Formatter {

    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" //Specify your format that you want
        return dateFormatter.string(from: date)
    }

}
