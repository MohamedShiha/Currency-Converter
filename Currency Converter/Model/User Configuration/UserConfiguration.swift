//
//  UserConfiguration.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

class UserConfiguration {
    
    private static let userDefaults = UserDefaults.standard
    
    public static func saveBaseCurrency(_ baseCurrency : Currency) {
        userDefaults.set( try? PropertyListEncoder().encode(baseCurrency), forKey: "baseCurrency")
        userDefaults.synchronize()
    }
    
    public static func loadBaseCurrency() -> Currency? {
        
        if let data = userDefaults.value(forKey: "baseCurrency") as? Data {
            return try? PropertyListDecoder().decode(Currency.self, from: data)
        } else {
            return Currency(image: UIImage(named: "USD")!, name: "US Dollar", code: "USD")
        }
    }
    
    public static func saveExchangeCurrencies(_ exchangeCurrencies : [CountedCurrency]) {
        userDefaults.set( try? PropertyListEncoder().encode(exchangeCurrencies), forKey: "exchangeCurrencies")
        userDefaults.synchronize()
    }
    
    public static func loadExchangeCurrencies() -> [CountedCurrency]? {

        if let data = userDefaults.value(forKey: "exchangeCurrencies") as? Data {
            return try? PropertyListDecoder().decode(Array<CountedCurrency>.self, from: data)
        } else {
            return [CountedCurrency(currency: Currency(image: UIImage(named: "EUR")!, name: "Euro", code: "EUR"), amount: 1)]
        }
    }
    
    public static func saveAmountInput(_ amount : Double) {
        userDefaults.set(amount, forKey: "amountInput")
        userDefaults.synchronize()
    }
    
    public static func loadAmountInput() -> Double {
        return userDefaults.double(forKey: "amountInput")
    }
}
