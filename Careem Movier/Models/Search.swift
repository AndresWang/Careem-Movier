//
//  Search.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

struct SearchRequest {
    var text: String
    var page: Int
    var successHandler: () -> Void
    var errorHandler: () -> Void
}
