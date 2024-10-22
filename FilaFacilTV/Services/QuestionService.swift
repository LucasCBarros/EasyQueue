//
//  QuestionService.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class QuestionService {
    
    func getAllQuestions(completion: @escaping (_ questions: [Question], _ error: Error?) -> Void) {
        let URL: String = "https://filafacildev.firebaseio.com/Questions.json"
        
        //creating a NSURL
        guard let url = NSURL(string: URL) else { return }
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL), completionHandler: {(data, response, error) in
            
            guard let data = data else {
                completion([Question](), error)
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
                var questions: [Question] = []
                
                for (_, elem) in json {
                    let jsonQuestion = elem as? [String: Any]
                    questions.append(Question(json: jsonQuestion!))
                }
                
                completion(questions, nil)
                
            } catch _ {
                completion([Question](), nil)
            }
        }).resume()
        
    }
}
