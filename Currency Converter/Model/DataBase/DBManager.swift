//
//  DBManager.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    
    static let viewContext = DataController.shared.viewContext
    
    static func create(_ conversion : Conversion) {
        
        let exchange = Exchange(context: viewContext)
        
        exchange.baseAmount = conversion.baseCountedCurrency.amount
        exchange.baseCurrencyImage = conversion.baseCountedCurrency.currency.image.encodeToCoreDataStore()
        exchange.baseCurrencyCode = conversion.baseCountedCurrency.currency.code
        exchange.baseCurrencyName = conversion.baseCountedCurrency.currency.name
        
        exchange.exchangeCurrencyImage = conversion.exchangeCountedCurrency.currency.image.encodeToCoreDataStore()
        exchange.exchangeCurrencyName = conversion.exchangeCountedCurrency.currency.name
        exchange.exchangeAmount = conversion.exchangeCountedCurrency.amount
        exchange.exchangeCurrencyCode = conversion.exchangeCountedCurrency.currency.code
        
        exchange.conversionDate = conversion.date
        
        try? viewContext.save()
    }
    
    static func read(predicate : NSPredicate) -> Exchange? {

        let exchange = Entity<Exchange>.fetchRecord(predicate: predicate, #keyPath(Exchange.conversionDate))
        
        if exchange != nil {
            return exchange!
        } else {
            print("No record to read")
            return nil
        }
    }
    
    static func readAll() -> [Exchange]? {
        
        let exchangeHistory = Entity<Exchange>.fetchAllRecords(#keyPath(Exchange.conversionDate))
        
        if exchangeHistory != nil {
            return exchangeHistory!
        } else {
            print("No all record to read")
            return nil
        }
    }
    
    static func update(predicate : NSPredicate, with newObject : Conversion) {
        
        let exchangeToUpdate = Entity<Exchange>.fetchRecord(predicate: predicate, #keyPath(Exchange.conversionDate))
        
        if exchangeToUpdate != nil {
            exchangeToUpdate!.baseAmount = newObject.baseCountedCurrency.amount
            exchangeToUpdate!.baseCurrencyImage = newObject.baseCountedCurrency.currency.image.encodeToCoreDataStore()
            exchangeToUpdate!.baseCurrencyCode = newObject.baseCountedCurrency.currency.code
            exchangeToUpdate!.baseCurrencyName = newObject.baseCountedCurrency.currency.name
            
            exchangeToUpdate!.exchangeAmount = newObject.exchangeCountedCurrency.amount
            exchangeToUpdate!.exchangeCurrencyImage = newObject.exchangeCountedCurrency.currency.image.encodeToCoreDataStore()
            exchangeToUpdate!.exchangeCurrencyCode = newObject.exchangeCountedCurrency.currency.code
            exchangeToUpdate!.exchangeCurrencyName = newObject.exchangeCountedCurrency.currency.name
            
            exchangeToUpdate!.conversionDate = newObject.date
            
            try? viewContext.save()
        } else {
            print("No record to update")
        }
    }
    
    static func delete(predicate : NSPredicate) {
        
        let exchangeToDelete = Entity<Exchange>.fetchRecord(predicate: predicate, #keyPath(Exchange.conversionDate))
        
        if exchangeToDelete != nil {
            viewContext.delete(exchangeToDelete!)
            try? viewContext.save()
        } else {
            print("No record to delete")
        }
    }
    
    static func deleteAll() {
        
        let exchangeHistory = Entity<Exchange>.fetchAllRecords(#keyPath(Exchange.conversionDate))
        
        if exchangeHistory != nil {
            for exchange in exchangeHistory! {
                viewContext.delete(exchange)
            }
            try? viewContext.save()
        } else {
            print("No all record to delete")
        }
    }
}
