//
//  NetworkMonitor.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/9/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    func checkReachable(_ completion : (_ connected : Bool) -> Void) {
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if isNetworkReachable(with : flags) {
            completion(true)
        } else if !isNetworkReachable(with: flags) {
            completion(false)
        }
    }
    
    private func isNetworkReachable(with flags : SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let isConnectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction)
    }
}
