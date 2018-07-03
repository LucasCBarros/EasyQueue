//
//  Timer.swift
//  FilaFacilWatch Extension
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 02/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class WatchTimer: NSObject {
    
    public static var startTime: Double?
    public static var stopTime: Double?
    public static var questionID: String?
    
    public static func deltaTime() -> TimeInterval? {
        if let stopTime = stopTime, let startTime = startTime {
            let time = stopTime - startTime
            return time
        } else {
            return nil
        }
    }
    
    public static func clearTimer() {
        self.startTime = nil
        self.stopTime = nil
        self.questionID = nil
    }
}
