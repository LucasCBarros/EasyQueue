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
    
    override init() {
        container = CKContainer(identifier: "iCloud.com.JoaoHergert.FilaFacil")
        publicDB  = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func retrieveAll<T: PersistenceObject>(dump: T.Type, path: String, completionHandler: @escaping ([T]?) -> Void) {
        var allObjects: [T] = []

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: path, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: {[weak self] (results, error) -> Void in
            if let error = error {
                print(error)
            } else if let results = results {
                
                for result in results {
                
                    var dictionary = result.dictionaryWithValues(forKeys: result.allKeys())
                    dictionary["recordId"] = result.recordID.recordName
                    dictionary["createdAt"] = result.creationDate
                    
                    let newObj = T(dictionary: dictionary)
                    
                        allObjects.append(newObj)
                }

                completionHandler(allObjects)
            
            }
        })
    }
}
