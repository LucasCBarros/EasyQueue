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
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd/MM - HH'h'mm" //Specify your format that you want
        return dateFormatter.string(from: date) + "min"
    }
    
    static func fullDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "eeee, dd 'de' MMMM 'de' yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func currentHour() -> String {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        
        return "\(dateComponents.hour!):\(dateComponents.minute!)h"
    }

}
