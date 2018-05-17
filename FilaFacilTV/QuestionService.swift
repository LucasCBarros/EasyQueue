//
//  QuestionService.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class QuestionService{
    func getJsonFromUrl(){
        let URL : String = "https://filafacildev.firebaseio.com/Questions.json"
        let url = NSURL(string: URL)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                OperationQueue.main.addOperation({
                    print(jsonObj)
                })
            }
        }).resume()
    }
}
