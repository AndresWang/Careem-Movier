//
//  Movie.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: Our own data model just in case​ ​we​ ​are​ ​asked​ ​to​ ​change​ ​to​ ​xml-based​ ​api​ ​instead​ ​of​ ​json, separation of concerns.
struct Movie {
    struct Response {
        var page: Int
        var total_results: Int
        var total_pages: Int
        var results: [Result]
    }
    struct Result {
        var title: String
        var poster_path: String
        var overview: String
        var release_date: String
    }
}
