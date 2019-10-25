//
//  ClientMethods.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CurrencyConverterClient {
    
    typealias availableCurrenciesHandler = ( _ availableCurrencies : [String:String]?, _ error : String?) -> Void
    
    func getAvailableCurrencies(completion : @escaping(availableCurrenciesHandler)) {
        
        getMethod([:], Methods.listCurrencies) { (data, error) in
            
            guard error == nil else {
                completion(nil, "Error occured while fetching data.")
                return
            }
            
            if let data = data {
                
                let jsonData = JSON(data)

                var availableCurrencies = [String:String]()
                if let currencies = jsonData[JsonResponseKeys.currencies].dictionary {
                    for (key, value) in currencies {
                        availableCurrencies[key] = value.stringValue
                    }
                    completion(availableCurrencies, nil)
                } else {
                    completion(nil, "Couldnt find \(JsonResponseKeys.currencies) key in the response")
                }
            } else {
                completion(nil, "No data found in the response.")
            }
        }
    }
    
    
    typealias converterHandler = (_ conversionRate : [String:[String:String]]?, _ error : String?) -> Void
    
    func convertCurrency(from : String = "", to : String = "", amount : Double = 1, completion : @escaping(converterHandler)) {
        
        let parameters = [
            CurrencyConverterClient.QueryParameterKeys.amount : amount,
            CurrencyConverterClient.QueryParameterKeys.from : from,
            CurrencyConverterClient.QueryParameterKeys.to : to
            ] as [String : AnyObject]
        
        getMethod(parameters, Methods.convert) { (data, error) in
            
            guard error == nil else {
                completion(nil, "Error occured while fetching data.")
                return
            }
            
            if let data = data {
                
                let jsonData = JSON(data)
                
                if let ratesData = jsonData[JsonResponseKeys.rates].dictionaryObject {
                    
                    var rates = [String:[String:String]]()
                    
                    for (key, value) in ratesData {
                        
                        let rate = value as? [String:String]
                        rates[key] = rate
                    }
                    
                    completion(rates, nil)
                } else {
                    completion(nil, "Couldnt find \(JsonResponseKeys.rates) key in the response")
                }
            } else {
                completion(nil, "No data found in the response.")
            }
        }
    }
}
