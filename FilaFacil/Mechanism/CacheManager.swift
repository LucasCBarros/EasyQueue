//
//  CacheManager.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 17/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Kingfisher

class CacheManager {
    
    static open private(set) var shared = CacheManager()
    
    static private let key = "imageDate"
    
    private init() {
        if let objects = UserDefaults.standard.object(forKey: CacheManager.key) as? [String: Date] {
            self.objects = objects
        }
    }
    
    fileprivate var objects = [String: Date]()
    
    private var semaphore = DispatchSemaphore(value: 1)
    
    func save(data: Data, with date: Date, in key: String) {
        self.semaphore.wait()
        self.objects[key] = date
        UserDefaults.standard.set(self.objects, forKey: CacheManager.key)
        self.semaphore.signal()
        if let image = UIImage(data: data) {
            KingfisherManager.shared.cache.store(image, forKey: key)
        }
    }
    
    func image(image: UIImage, with date: Date, in key: String) {
        self.semaphore.wait()
        self.objects[key] = date
        self.semaphore.signal()
        KingfisherManager.shared.cache.store(image, forKey: key)
    }
    
    func remove(with objectKey: String) {
        self.semaphore.wait()
        self.objects.removeValue(forKey: objectKey)
        UserDefaults.standard.set(self.objects, forKey: CacheManager.key)
        self.semaphore.signal()
        KingfisherManager.shared.cache.removeImage(forKey: objectKey)
    }
    
    func retrieveImage(for objectKey: String) -> UIImage? {
        return KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: objectKey)
    }
    
    func retrieveLastModificationDate(for objectKey: String) -> Date? {
        self.semaphore.wait()
        let date = self.objects[objectKey]
        self.semaphore.signal()
        return date
    }
    
    func retrieveData(for objectKey: String) -> Data? {
        if let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: objectKey) {
            return UIImagePNGRepresentation(image)
        } else {
            return nil
        }
    }
    
}
