//
//  String.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 25/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
