//
//  Constants.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

class CurrencyConverterClient {
    
    static let instance = CurrencyConverterClient()
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "currency-converter5.p.rapidapi.com"
        static let ApiPath = "/currency"
        
        static let ApiKey = "6989cc8705msh2f444c88635ae2cp1e2777jsn37fac6a6847d"
    }
    
    struct Methods {
        static let listCurrencies = "/list"
        static let convert = "/convert"
    }
    
    struct QueryParameterKeys {
        static let to = "to"
        static let from = "from"
        static let amount = "amount"
    }
    
    struct HeaderParameter {
        static let ApiKey = "x-rapidapi-key"
    }
    
    struct JsonResponseKeys {
        static let currencies = "currencies"
        static let rates = "rates"
        static let rateForAmount = "rate_for_amount"
    }
    
    
    // Mark: Helpers
    
    func constructUrl(_ parameters : [String:AnyObject], with pathExtentsion : String?) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (pathExtentsion ?? "")

        var queryItems = [URLQueryItem]()
        for (key,value) in parameters {
            queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
        }
        components.queryItems = queryItems
    
        return components.url!
    }
}
