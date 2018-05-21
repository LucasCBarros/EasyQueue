//
//  LineQuestion.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 20/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import UIKit

//TODO: Gostaria que isso fosse um enum e que fosse da camada de model e por isso não importasse UIKit

enum CategoryQuestionType {
    case developer
    case design
    case business
    case other
}

class CategoryQuestion {
    var title: String
    var color: UIColor
    var type: CategoryQuestionType
    
    
    init(type: CategoryQuestionType){
        self.type = type
        
        switch type {
        case .developer:
            title = "Developer"
            color = #colorLiteral(red: 0, green: 0.4462612271, blue: 0.8034006357, alpha: 1)
        case .design:
            title = "Desing"
            color = #colorLiteral(red: 0.9390600324, green: 0.7066840529, blue: 0, alpha: 1)
        case .bisness:
            title = "Business"
            color = #colorLiteral(red: 0.3411764706, green: 0.6078431373, blue: 0.05098039216, alpha: 1)
        case .other:
            title = "Other"
            color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
}
