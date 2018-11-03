//
//  QuestionService.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class NoteService {
    
//    func getAllQuestions(completion: @escaping (_ questions: [Note], _ error: Error?) -> Void) {
////        let URL: String = "https://fila-facil.firebaseio.com/Notes.json"
////        let URL: String = "https://filafacildev.firebaseio.com/Notes.json"
//        
//        //creating a NSURL
////        guard let url = NSURL(string: URL) else { return }
//        
//        //fetching the data from the url
//        URLSession.shared.dataTask(with: (url as URL), completionHandler: {(data, _, error) in
//            
//            guard let data = data else {
//                completion([Note](), error)
//                return
//            }
//            
//            do {
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                
//                var notes: [Note] = []
//                
//                for (_, elem) in json {
//                    let jsonQuestion = elem as? [String: Any]
//                    notes.append(Note(json: jsonQuestion!))
//                }
//                
//                completion(notes, nil)
//                
//            } catch _ {
//                completion([Note](), nil)
//            }
//        }).resume()
//        
//    }
}
