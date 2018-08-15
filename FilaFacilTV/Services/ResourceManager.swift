//
//  ResourceManager.swift
//  FilaFacilTV
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 15/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class ResourceManager {
    
    static let shared = ResourceManager()
    
    private init() { }
    
    func requestVideoWith(tag: String, completionHandler: @escaping (Error?) -> Void) -> NSBundleResourceRequest {
        
        let videoRequest = NSBundleResourceRequest(tags: [tag])
        videoRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        
        videoRequest.beginAccessingResources { (error) in
            OperationQueue.main.addOperation {
                completionHandler(error)
            }
        }
             
        return videoRequest
    }
    
}
