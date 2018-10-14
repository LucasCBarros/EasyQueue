//
//  TermsController.swift
//  FilaFacil
//
//  Created by Ellen Mota on 13/10/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class TermsController: UIViewController {

    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        termsTextView.isEditable = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.addTerms()
    }
    
    //Adiciona os Termos para o TextView
    func addTerms(){
        let path = Bundle.main.path(forResource:"Terms", ofType: "txt")
        
        let url = URL(fileURLWithPath: path!)
        do{
            
            let contentString =  try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
            termsTextView.text = contentString as String
            
        } catch let error as NSError{
            print("Error \(error)")
        }
    }
}
