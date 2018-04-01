//
//  Search.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: Data model for SearchViewTrait to initiate a search request
struct SearchRequest {
    var text: String
    var page: Int
    // (searchText: String?, isLoadMore: Bool), searchText != nil means a successful query
    var successHandler: (String?, Bool) -> Void
    var errorHandler: () -> Void
}
