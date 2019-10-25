//
//  RequestMethods.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import Alamofire

extension CurrencyConverterClient {
    
    func getMethod(_ parameters : [String:AnyObject], _ method : String, completion : @escaping(_ data : Dictionary<String,AnyObject>?, _ error : Error?) -> Void) {
        
        let url = constructUrl(parameters, with: method)

        var request = URLRequest(url: url)
        
        request.addValue(Constants.ApiKey, forHTTPHeaderField: HeaderParameter.ApiKey)
        
        Alamofire.request(request).responseJSON { (response) in
            
            let result = response.result
            
            guard result.isSuccess else {
                completion(nil , result.error)
                return
            }
            
            if let value = result.value as? Dictionary<String,AnyObject> {
                completion(value , nil)
            }
        }
    }
}
