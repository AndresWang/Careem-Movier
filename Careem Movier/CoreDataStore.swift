//
//  CoreDataStore.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// Note: We use protocol interface for database communication just in case we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​persistent​ ​store​.
protocol DataStoreDelegate {
    
}

// Note: We use CoreData as our DataStoreDelegate
extension CoreDataStore: DataStoreDelegate {
    
}
