//
//  LineDAO.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 09/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class LineDAO: NSObject {
    
    func fetchAllLines(_ completionHandler: ([Line]?, Error?) -> Void) {
        
        var lines: [Line] = []
        
        lines.append(Line(lineId: "0", name: "Developer", color: Color(red: 51.0 / 255.0, green: 164.0 / 255.0, blue: 255.0 / 255.0)))
        lines.append(Line(lineId: "1", name: "Design", color: (try? Color(with: "F6713D"))!))
        lines.append(Line(lineId: "2", name: "Business", color: (try? Color(with: "EEB307"))!))
        
        completionHandler(lines, nil)
    }
    
}
