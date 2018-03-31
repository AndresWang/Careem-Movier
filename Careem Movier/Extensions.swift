//
//  Extensions.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

extension URL {
    static func moviedb(searchText: String, page: Int) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=%@&page=%ld", encodedText, page)
        return URL(string: searchTerm)!
    }
    static func moviedbImage(size: MoviedbImageSize, path: String) -> URL {
        return URL(string: "http://image.tmdb.org/t/p" + size.rawValue + path)!
    }
}
