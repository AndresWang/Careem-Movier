//
//  Query.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/4/1.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// Note: Our own model separated from data store just in case​ ​we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​persistent​ ​store
struct Query {
    var text: String
    var date: Date
}

class ManagedQuery: NSManagedObject {
    @NSManaged var text: String?
    @NSManaged var date: Date?
    
    enum Keys: String {
        case text
        case date
    }
    
    // MARK: - Helper Methods
    class func entityName() -> String {
        return "ManagedQuery"
    }
    func toQuery() -> Query {
        return Query(text: text!, date: date!)
    }
}
