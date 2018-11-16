//
//  TransparentNavigationController.swift
//  SoDevIOS
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 13/11/18.
//  Copyright © 2018 SAS. All rights reserved.
//

import UIKit

@IBDesignable class TransparentNavigationController: UINavigationController {
    
    private var oldBackGroundImage: UIImage?
    private var oldShadowImage: UIImage?
    private var oldBackgroundColor: UIColor?
    private var oldIsTranslucent: Bool = true
    
    @IBInspectable var isBarTransparent: Bool = false {
        didSet {
            if !oldValue && isBarTransparent {
                self.oldBackGroundImage = self.navigationBar.backgroundImage(for: .default)
                self.oldShadowImage = self.navigationBar.shadowImage
                self.oldBackgroundColor = self.navigationBar.backgroundColor
                self.oldIsTranslucent = self.navigationBar.isTranslucent
                
                self.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationBar.shadowImage = UIImage()
                self.navigationBar.backgroundColor = .clear
                self.navigationBar.isTranslucent = true
            } else if !isBarTransparent {
                self.navigationBar.setBackgroundImage(self.oldBackGroundImage, for: .default)
                self.navigationBar.shadowImage = self.oldShadowImage
                self.navigationBar.backgroundColor = self.oldBackgroundColor
                self.navigationBar.isTranslucent = self.oldIsTranslucent
            }
        }
    }

}
