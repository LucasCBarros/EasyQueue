//
//  ExtensionsWatch.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

// Extension imported to expose image by URL
public extension WKInterfaceImage {
    
    public func setImageWithUrl(url: String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, _, error in
            if data != nil && error == nil {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
            }.resume()
        
        return self
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
        let color = #colorLiteral(red: 0.9647058824, green: 0.4431372549, blue: 0.2392156863, alpha: 1)
        return color
    }
    
    static func business() -> UIColor {
        let color = #colorLiteral(red: 0.9333333333, green: 0.7019607843, blue: 0.02745098039, alpha: 1)
        return color
    }
    
}
