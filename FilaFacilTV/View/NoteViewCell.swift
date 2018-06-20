//
//  NoteView.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 21/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteViewCell: UICollectionViewCell {
    
    static fileprivate var column:(left: CGPoint, right: CGPoint)?
        
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
//    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        let screenWidth = UIScreen.main.bounds.size.width * (13/40) / 2 - 10
//        widthConstraint.constant = screenWidth - (2 * 12)
    }
    
}
