//
//  Line.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 09/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

enum ColorErrors: Error {
    case invalidHexadecimal
    case invalidRed
    case invalidGreen
    case invalidBlue
}

fileprivate extension String {
    subscript(index: Int) -> String? {
        get {
            return String(Array(self)[index])
        }
        set {
            if let newValue = newValue, index < self.count {
                var array = Array(self)
                array[index] = Character(newValue)
                self = String(array)
            }
        }
    }
    
    subscript(index: (Int, Int)) -> String? {
        get {
            var retorno = String()
            for index in index.0...index.1 {
                if let character = self[index] {
                    retorno.append(character)
                }
            }
            return retorno
        }
        set {
            if let newValue = newValue, index.0 - index.1 > newValue.count {
                var indexCharacter = 0
                for index in index.0...index.1 {
                    var array = Array(self)
                    array[index] = Character(newValue[indexCharacter]!)
                    self = String(array)
                    indexCharacter += 1
                }
            }
        }
    }
}

/// Represents a RGB color.
struct Color {
    
    /// A value between 0 and 1 (255) to the red.
    let red: Float
    /// A value between 0 and 1 (255) to the green.
    let green: Float
    /// A value between 0 and 1 (255) to the blue.
    let blue: Float
    
    /// Initializer with a hexadecimal.
    ///
    /// - Parameter hexadecimal: String with five characters that represents the hexadecimal.
    /// - Throws: ColorsErrors
    init(with hexadecimal: String) throws {
        guard hexadecimal.count == 6 else {
            throw ColorErrors.invalidHexadecimal
        }
        guard let red = UInt8(hexadecimal[(0, 1)]!, radix: 16) else {
            throw ColorErrors.invalidRed
        }
        guard let green = UInt8(hexadecimal[(2, 3)]!, radix: 16) else {
            throw ColorErrors.invalidGreen
        }
        guard let blue = UInt8(hexadecimal[(4, 5)]!, radix: 16) else {
            throw ColorErrors.invalidBlue
        }
        
        self.red = Float(red) / 255.0
        self.green = Float(green) / 255.0
        self.blue = Float(blue) / 255.0
    }
    
    init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
}

protocol LineProtocol: class {
    var lineId: String {get set}
    var name: String {get set}
    var color: Color {get set}
}

/// Represents a line.
class Line: LineProtocol {
    
    open internal(set) var lineId: String
    open var name: String
    open var color: Color
    
    /// Init Line
    ///
    /// - Parameters:
    ///   - lineId: A string that represents the id.
    ///   - name: Line name.
    ///   - color: Color associated with the line.
    init(lineId: String, name: String, color: Color) {
        self.lineId = lineId
        self.name = name
        self.color = color
    }
    
}
