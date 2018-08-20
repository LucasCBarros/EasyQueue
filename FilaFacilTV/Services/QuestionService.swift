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
        // AppStore Submission Server:
//        let URL: String = "https://filafacil-submission.firebaseio.com/"
        
        // Production Server:
//        let URL: String = "https://fila-facil.firebaseio.com/Lines.json"
        
        // Development Server:
        let URL: String = "https://filafacildev.firebaseio.com/Lines.json"
        
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
                
                for (categoryLine , line) in json {
                    if let line = line as? [String: Any] {
                        for (_ , elem) in line {
                            var jsonQuestion = elem as? [String: Any]
                            jsonQuestion?["requestedTeacher"] = categoryLine
                            questions.append(Question(json: jsonQuestion!))
                        }
                    }
                }
                
                questions = questions.sorted(by: {(question1, question2) in
                    return question1.questionID < question2.questionID
                })
                
                completion(questions, nil)
                
            } catch _ {
                completion([Question](), nil)
            }
        }).resume()
        
    }
}
