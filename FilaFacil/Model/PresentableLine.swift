//
//  PersistanceLine.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 10/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class PresentableLine: LineProtocol {
    
    open internal(set) var lineId: String
    open var name: String
    open var color: Color
 
    /// Represents whether the line is visible. Default is false.
    open var isSelected: Bool
    
    fileprivate static let defaultSelected: Bool = false
    
    /// PresentableLine initializer.
    ///
    /// - Parameters:
    ///   - line: The presented Line.
    ///   - isSelected: Represents whether the line is visible. Default is false.
    init(with line: Line, isSelected: Bool = PresentableLine.defaultSelected) {
        self.lineId = line.lineId
        self.color = line.color
        self.name = line.name
        self.isSelected = isSelected
    }
    
}
