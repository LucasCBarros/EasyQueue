//
//  NewQuestionTableViewCell.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 30/05/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NewQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var typeQuestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkView.clipsToBounds = true
        checkView.layer.borderColor = UIColor.white.cgColor
        checkView.layer.cornerRadius = checkView.frame.width / 2
        checkView.layer.borderWidth = 2
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
