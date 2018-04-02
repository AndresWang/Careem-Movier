//
//  TestCoreDataStore.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/4/2.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// CoreDataStore of NSInmemoryStore type for Unit test
class TestCoreDataStore: CoreDataStore {
    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {print("Unresolved error \(error), \(error.userInfo)")}
        }
        
        self.storeContainer = container
    }
}
