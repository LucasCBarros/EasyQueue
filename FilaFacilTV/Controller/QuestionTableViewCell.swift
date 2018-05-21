//
//  QuestionTableViewCell.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//
import UIKit
import Foundation

class QuestionTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var viewTypeQuestion: UIView!
    @IBOutlet weak var timeInputQuestion: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            self.questionLabel.textColor = UIColor.black
            self.profileName.textColor = UIColor.black
            self.timeInputQuestion.textColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
        } else {
            self.questionLabel.textColor = UIColor.white
            self.profileName.textColor = UIColor.white
            self.timeInputQuestion.textColor = UIColor.white
        }
    }
    
}
