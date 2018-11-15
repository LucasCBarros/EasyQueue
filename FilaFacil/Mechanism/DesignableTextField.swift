//
//  DesignableTextField.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 15/11/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextField: UITextField {
    
    
    @IBInspectable var leftImage:UIImage? {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var widthImageView: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var heightImageView: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage{
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0.0, width: widthImageView, height: heightImageView))
            imageView.image = image
            leftView = UIImageView(frame: CGRect(x: 0, y: 0, width: leftPadding + widthImageView, height: heightImageView))
            leftView?.addSubview(imageView)
        } else {
            leftViewMode = .never
        }
    }
    
}
