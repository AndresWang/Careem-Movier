//
//  MoviedbJSON.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

enum MoviedbImageSize: String {
    case small = "/w92"
    case medium = "/w185"
    case large = "​/w500"
    case extraLarge = "/w780"
}

struct JSON {
    struct Response: Codable {
        var page: Int
        var total_results: Int
        var total_pages: Int
        var results: [Result]
    }
    
    struct Result: Codable {
        var title: String
        var poster_path: String
        var overview: String
        var release_date: String
    }
}
