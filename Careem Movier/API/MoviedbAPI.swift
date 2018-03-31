//
//  MoviedbAPI.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

class MoviedbAPI {
    weak var output: APIOutputDelegate?
    var searchTask: URLSessionDataTask?
    
    init(output: APIOutputDelegate) {
        self.output = output
    }
    
    enum PosterSize: String {
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
            
            func toMovie() -> Movie.Response {
                return Movie.Response(page: page, total_results: total_results, total_pages: total_pages, results: results.map{$0.toMovie()})
            }
        }
        struct Result: Codable {
            var title: String
            var poster_path: String
            var overview: String
            var release_date: String
            
            func toMovie() -> Movie.Result {
                return Movie.Result(title: title, poster_path: poster_path, overview: overview, release_date: release_date)
            }
        }
    }
}


