//
//  CoreDataStack.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore {
    static let sharedInstance = CoreDataStore()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Careem_Movier")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {print("Unresolved error \(error), \(error.userInfo)")}
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {return storeContainer.viewContext}()
    
    func saveContext() {
        guard context.hasChanges else {return}
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
