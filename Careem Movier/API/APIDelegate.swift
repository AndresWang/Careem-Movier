//
//  APIDelegate.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: Protocol interface for api communication just in case we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​api​.
protocol APIDelegate: class {
    var output: APIOutputDelegate? {get set}
    var searchTask: URLSessionDataTask? {get set}
    func getData()
}

// Note: For asynchronous network purpose, and in this case its output is our SearchInteractor.
protocol APIOutputDelegate: class {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?)
}

// Note: MoviedAPI as our DataStoreDelegate
extension MoviedbAPI: APIDelegate {
    // MARK: - Boundary Methods
    func getData() {
        
    }
    
    // MARK: - Private Methods
    private func searchURL(with text: String, page: Int) -> URL {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let searchTerm = String(format: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=%@&page=%ld", encodedText, page)
        return URL(string: searchTerm)!
    }
    private func imageURL(size: PosterSize, path: String) -> URL {
        return URL(string: "http://image.tmdb.org/t/p" + size.rawValue + path)!
    }
}
