//
//  DataController.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/1/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController(modelName: "ExchangeHistory")
    
    private let persistentContainer : NSPersistentContainer
    
    init(modelName : String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load (completion : (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
}
