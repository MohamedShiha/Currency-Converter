//
//  ImageFormatter.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/28/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

typealias ImageData = Data

extension UIImage {
    
    func encodeToCoreDataStore() -> ImageData? {
        guard let imageRepresentation = self.pngData() else {
            print("Unable to represent image as PNG")
            return nil
        }
        let data : NSData = NSData(data: imageRepresentation)
        
        return try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
    }
}

extension ImageData {
    
    func decodeFromCoreDataStore() -> UIImage? {
        if let storedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) {
            return UIImage(data: storedData as! Data)
        } else {
            print("Unable to convert data to Image Array")
            return nil
        }
    }
}
