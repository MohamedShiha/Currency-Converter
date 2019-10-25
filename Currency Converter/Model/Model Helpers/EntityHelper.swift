//
//  EntityHelper.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/2/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import CoreData

class Entity<T> where T: NSManagedObject {
    
    static func fetchRecord(predicate : NSPredicate, _ sortAttribute : String) -> T? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        let sortDescriptor = NSSortDescriptor(key: sortAttribute, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = predicate
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            return result[0]
        } else {
            return nil
        }
    }
    
    static func fetchAllRecords(_ sortAttribute : String) -> [T]? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        let sortDescriptor = NSSortDescriptor(key: sortAttribute, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            return result
        } else {
            return nil
        }
    }
}
