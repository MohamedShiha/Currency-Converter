//
//  ConversionHistory.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/6/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

struct Conversion {
    var baseCountedCurrency : CountedCurrency!
    var exchangeCountedCurrency : CountedCurrency!
    var date : Date!
    
    static func parseObject(_ exchange: Exchange?) -> Conversion? {
        
        if let exchange = exchange {
            
            let baseCountedCurrency = CountedCurrency(currency: Currency(image: (exchange.baseCurrencyImage?.decodeFromCoreDataStore())!, name: exchange.baseCurrencyName!, code: exchange.baseCurrencyCode!), amount: exchange.baseAmount)
            
            let exchangeCountedCurrency = CountedCurrency(currency: Currency(image: (exchange.exchangeCurrencyImage?.decodeFromCoreDataStore())!, name: exchange.exchangeCurrencyName!, code: exchange.exchangeCurrencyCode!), amount: exchange.exchangeAmount)
            
            let conversion = Conversion(baseCountedCurrency: baseCountedCurrency, exchangeCountedCurrency: exchangeCountedCurrency, date: exchange.conversionDate)
            
            return conversion
        } else {
            return nil
        }
    }
}
