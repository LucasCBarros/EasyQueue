//
//  PresentedLinesService.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 01/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

final class PresentedLinesManager {
    
    private static let key = "lines"
    
    public private(set) static var shared = PresentedLinesManager()
    
    private var _lines: Set<String> = []
    
    public private(set) var lines: Set<String> {
        get {
            self.externalSemaphore.wait()
            let lines = self._lines
            self.externalSemaphore.signal()
            return lines
        }
        set {
            self.externalSemaphore.wait()
            self._lines = newValue
            self.externalSemaphore.signal()
        }
    }
    
    private let internalSemaphore = DispatchSemaphore(value: 1)
    private let externalSemaphore = DispatchSemaphore(value: 1)
    
    private init() {
        var finalLines: Set<String> = []
        if let data = UserDefaults.standard.value(forKey: PresentedLinesManager.key) as? Data,
            let lines = NSKeyedUnarchiver.unarchiveObject(with: data) as? Set<String> {
            finalLines = lines
        }
        self.internalSemaphore.wait()
        self.lines = finalLines
        self.internalSemaphore.signal()
    }
    
    public func add(_ line: String) {
        self.internalSemaphore.wait()
        self.lines.insert(line)
        let data = NSKeyedArchiver.archivedData(withRootObject: self.lines)
        UserDefaults.standard.setValue(data, forKey: PresentedLinesManager.key)
        self.internalSemaphore.signal()
    }
    
    public func remove(_ line: String) {
        self.internalSemaphore.wait()
        self.lines.remove(line)
        let data = NSKeyedArchiver.archivedData(withRootObject: self.lines)
        UserDefaults.standard.setValue(data, forKey: PresentedLinesManager.key)
        self.internalSemaphore.signal()
    }
    
}
