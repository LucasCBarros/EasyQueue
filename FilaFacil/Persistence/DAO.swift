//
//  DAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

protocol PersistenceObject {
    init(dictionary: [AnyHashable: Any])
    func getDictInfo() -> [AnyHashable: Any]
}

class DAO: NSObject {
    
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    //var ref: DatabaseReference!
    
    override init() {
        //super.init()
        //ref = Database.database().reference()
        //ref.keepSynced(true)
        
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func retrieveAll<T: PersistenceObject>(dump: T.Type, path: String, completionHandler: @escaping ([T]?) -> Void) {
        var allObjects: [T] = []

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Question", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: {[weak self] (results, error) -> Void in
            if let error = error {
                print(error)
            } else if let results = results {
                
                for result in results {
                
                    let dictionary = result.dictionaryWithValues(forKeys: result.allKeys())
                    
                   // for key in dictionary.keys {
                       // let objectDict = dictionary[key] as? [String: Any]
                        
                       // let newObj = T(dictionary: objectDict!)
                        let newObj = T(dictionary: dictionary)
//                        let testeDict = ["username": "Joao",
//                                                "questionID": "1111",
//                                                "questionTitle": "Duvida de teste",
//                                                "userID": "1111",
//                                                "requestedTeacher": "Developer",
//                                                "userPhoto": "dwdwdwdw"]
                    
                        allObjects.append(newObj)
                    //}
                }
                completionHandler(allObjects)
            
                
            }
        })
    }
            
        
        
        
//        ref?.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//
//                for key in dictionary.keys {
//                    let objectDict = dictionary[key] as? [String: Any]
//
//                    let newObj = T(dictionary: objectDict!)
//
//                    allObjects.append(newObj)
//                }
//
//            }
//            completionHandler(allObjects)
//        })
//    }
//
//    // Returns an Profile by ID
//    func retrieveByID<T: PersistenceObject>(dump: T.Type, path: String, completionHandler: @escaping ([T]?) -> Void) {
//        var allObjects: [T] = []
//
//        ref?.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//
//                for key in dictionary.keys {
//                    let objectDict = dictionary[key] as? [String: Any]
//
//                    let newObj = T(dictionary: objectDict!)
//
//                    allObjects.append(newObj)
//                }
//
//                completionHandler(allObjects)
//            } else {
//                completionHandler(nil)
//            }
//        })
//    }
//
//    func editByID<T: PersistenceObject>(dump: T.Type, newObject: T, path: String, objectID: String) {
//        let dict = newObject.getDictInfo()
//
//        ref?.child(path).child(objectID).updateChildValues(dict)
//    }
//
//    func create<T: PersistenceObject>(dump: T.Type, object: T, path: String, newObjectID: String?) {
//        let newID = (newObjectID == nil) ? ref?.child(path).childByAutoId().key : newObjectID
//
//        var dict = object.getDictInfo()
//
//        dict["userID"] = newID
//
//        ref?.child(path).child(newID!).setValue(dict)
//    }
//
//    func createDetailedWithTimeStampID(path: String, fields: [String], info: [String]) {
//
//        let timeStampID = Date().millisecondsSince1970 //"\(Int(NSDate.timeIntervalSinceReferenceDate*1000))"
//        print("##########", timeStampID)
//        let pathWithID = path + String(timeStampID)
//
//        for field in 0..<fields.count {
//            ref?.child(pathWithID).child(fields[field]).setValue(info[field])
//        }
//    }
}
