//
//  DataStoreDelegate.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// Note: Protocol interface for database communication just in case we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​persistent​ ​store​.
protocol DataStoreDelegate {
    func saveSuccessfulQuery(text: String)
    func fetchSuggestionQueries() -> [Query]
}

// Note: CoreData as our DataStoreDelegate
extension CoreDataStore: DataStoreDelegate {
    // MARK: - Boundary Methods
    func saveSuccessfulQuery(text: String) {
        // Avoid duplicate queries
        if let hasQuery = findQuery(withText: text) {
            hasQuery.date = Date()
        } else {
            let newQuery = NSEntityDescription.insertNewObject(forEntityName: ManagedQuery.entityName(), into: context) as! ManagedQuery
            newQuery.text = text
            newQuery.date = Date()
        }
        
        // Delete oldest one if there are more than 10 records
        let queries = fetchSortedQueriesWithNewestFirst()
        if queries.count > 10 {context.delete(queries.last!)}
        saveContext()
    }
    func fetchSuggestionQueries() -> [Query] {
        return fetchSortedQueriesWithNewestFirst().map{$0.toQuery()}
    }
    
    // MARK: - Private Methods
    /// The search is case insensitive
    private func findQuery(withText text: String) -> ManagedQuery? {
        let fetchRequest = NSFetchRequest<ManagedQuery>(entityName: ManagedQuery.entityName())
        let predicate = NSPredicate(format: "%K ==[c] %@", ManagedQuery.Keys.text.rawValue, text)
        fetchRequest.predicate = predicate
        do {
            let matchedQueries = try context.fetch(fetchRequest)
            return matchedQueries.first
        } catch {
            print(error)
            return nil
        }
    }
    private func fetchSortedQueriesWithNewestFirst() -> [ManagedQuery] {
        let fetchRequest = NSFetchRequest<ManagedQuery>(entityName: ManagedQuery.entityName())
        let sortDescriptor = NSSortDescriptor(key: ManagedQuery.Keys.date.rawValue, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let managedQueries = try context.fetch(fetchRequest)
            return managedQueries
        } catch {
            print(error)
            return []
        }
    }
}
