//
//  Formatter.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 30/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class Formatter {
    
    static var currentDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter
    }

    static func dateToString(_ date: Date) -> String {
        let dateFormatter = currentDateFormatter
        dateFormatter.dateFormat = "dd/MM - HH'h'mm" //Specify your format that you want
        return dateFormatter.string(from: date) + "min"
    }
    
    static func fullDateToString(_ date: Date) -> String {
        let dateFormatter = currentDateFormatter
        dateFormatter.dateFormat = "eeee, dd 'de' MMMM 'de' yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func currentHour() -> String {
        let dateFormatter = currentDateFormatter
        dateFormatter.dateFormat = "HH:mm'h'"
        return dateFormatter.string(from: Date())
    }

}
