//
//  LineService.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 09/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

/// Services associated with the Lines.
class LineService: NSObject {
    
    public static let shared = LineService()
    
    private override init() { }
    
    private let lineDAO = LineDAO()
    
    /// Fetch all lines.
    ///
    /// - Parameter completionHandler: A code block for when the operation is complete.
    open func fetchAllLines(onlySelected: Bool, _ completionHandler: ([PresentableLine]?, Error?) -> Void) {
        lineDAO.fetchAllLines { (lines, error) in
            if let lines = lines, error == nil {
                guard lines.count != 0 else {
                    completionHandler([PresentableLine](), nil)
                    return
                }
                var presentedLines = PresentedLinesManager.shared.lines
                if presentedLines.count == 0 {
                    for line in lines {
                        PresentedLinesManager.shared.add(line.name)
                        presentedLines.insert(line.name)
                    }
                }
                
                let onlySelected = !onlySelected
                
                let presentableLines = lines.reduce(into: [PresentableLine](), { (lines, line) in
                    if presentedLines.contains(line.name) {
                        lines.append(PresentableLine(with: line, isSelected: true))
                    } else if onlySelected {
                        lines.append(PresentableLine(with: line))
                    }
                })
                completionHandler(Array(presentableLines), nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
