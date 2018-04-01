//
//  Search.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: A data model for SearchViewTrait to initiate a search request
struct SearchRequest {
    var text: String
    var page: Int
    // Search text != nil -> Successful Query
    var successHandler: (String?) -> Void
    var errorHandler: () -> Void
}
