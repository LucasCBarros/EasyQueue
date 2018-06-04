//
//  Extensions.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: completionHandler))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    
    // Personal Colors
    func UIBlack() -> UIColor {
        let UIBlack = UIColor(red: 40/255, green: 43/255, blue: 53/255, alpha: 1.0)
        return UIBlack
    }
    
    func UIGreen() -> UIColor {
        let UIGreen = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        return UIGreen
    }
    
    static func developer() -> UIColor {
        let color = #colorLiteral(red: 0.03921568627, green: 0.4549019608, blue: 0.7921568627, alpha: 1)
        return color
    }
    
    static func design() -> UIColor {
        let color = #colorLiteral(red: 0.9390600324, green: 0.7066840529, blue: 0, alpha: 1)
        return color
    }

    static func business() -> UIColor {
        let color = #colorLiteral(red: 0.3411764706, green: 0.6078431373, blue: 0.05098039216, alpha: 1)
        return color
    }
    
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    var millisecondsSinceNow: Int64 {
        return Int64((self.timeIntervalSinceNow * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
