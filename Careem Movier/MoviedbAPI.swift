//
//  MoviedbAPI.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

struct MoviedbAPI {
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
        }
        
        struct Result: Codable {
            var title: String
            var poster_path: String
            var overview: String
            var release_date: String
        }
    }
    
    // MARK: Helper Methods
    static func searchURL(with text: String, page: Int) -> URL {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=%@&page=%ld", encodedText, page)
        return URL(string: searchTerm)!
    }
    static func imageURL(size: PosterSize, path: String) -> URL {
        return URL(string: "http://image.tmdb.org/t/p" + size.rawValue + path)!
    }
}


