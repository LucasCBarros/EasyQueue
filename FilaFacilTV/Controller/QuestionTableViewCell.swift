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
    
}
