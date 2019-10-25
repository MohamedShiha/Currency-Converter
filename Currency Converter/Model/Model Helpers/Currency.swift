//
//  Currency.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/6/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

struct Currency : Codable, Equatable {
    var image : UIImage!
    var name : String!
    var code : String!

    enum CodingKeys : CodingKey {
        case image, name, code
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let imageData = try container?.decode(Data.self, forKey: .image) {
            if let image = UIImage(data: imageData) {
                self.image = image
            }
        }
        name = try container?.decode(String.self, forKey: .name)
        code = try container?.decode(String.self, forKey: .code)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image.pngData(), forKey: .image)
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
    }
    
    init(image : UIImage, name : String, code : String) {
        self.image = image
        self.name = name
        self.code = code
    }
    
    static func getCurrencyImage(fromCode currencyCode : String) -> UIImage? {
        if let image = UIImage(named: currencyCode) {
            return image
        } else {
            return nil
        }
    }
}
