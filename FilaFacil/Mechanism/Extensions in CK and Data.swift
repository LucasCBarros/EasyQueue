//
//  Extensions in CK and Data.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 07/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import CloudKit
import UIKit

extension CKAsset {
    
    convenience init(image: UIImage) {
        let documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let tempImageName = "Image2.png"
        
        let imageData = UIImagePNGRepresentation(image)
        let path = documentsDirectoryPath.appendingPathComponent(tempImageName)
        let url = URL(fileURLWithPath: path)
        try? imageData?.write(to: url, options: [.atomic])
        
        self.init(fileURL: url)
    }
    
    func image() -> UIImage? {
        let data = try? Data(contentsOf: self.fileURL)
        
        let image = UIImage(data: data!)
        return image
    }
    
}
