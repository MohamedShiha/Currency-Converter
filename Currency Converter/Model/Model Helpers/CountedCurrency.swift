//
//  CountedCurrency.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/6/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

struct CountedCurrency : Codable, Equatable {
    var currency : Currency!
    var amount : Double!
}
