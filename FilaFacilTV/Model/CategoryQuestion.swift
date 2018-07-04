//
//  LineQuestion.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 20/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import UIKit

enum CategoryQuestionType: String {
    case developer = "Developer"
    case design = "Design"
    case business = "Business"
    case other = ""
}

class CategoryQuestion {
    var title: String
    var color: UIColor
    var type: CategoryQuestionType
    
    init(type: CategoryQuestionType) {
        self.type = type
        
        switch type {
        case .developer:
            title = "Developer"
            color = UIColor.developer()
        case .design:
            title = "Desing"
            color = UIColor.design()
        case .business:
            title = "Business"
            color = UIColor.business()
        case .other:
            title = "Other"
            color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
}
