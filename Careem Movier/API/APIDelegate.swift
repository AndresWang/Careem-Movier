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
    var output: APIOutputDelegate? {get}
    var dataTask: URLSessionDataTask? {get}
    func startDataTask(url: URL)
}

// Note: For asynchronous network purpose, and in this case its output is our SearchInteractor.
protocol APIOutputDelegate: class {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?)
}

// Note: MoviedAPI as our DataStoreDelegate
extension MoviedbAPI: APIDelegate {
    // MARK: - Boundary Methods
    func startDataTask(url: URL) {
        dataTask?.cancel()
        
        // Start URLSession
        let session = URLSession.shared
        dataTask = session.dataTask(with: url) { data, response, error in
            self.output?.didRecieveResponse(data: data, response: response, error: error)
        }
        dataTask?.resume()
    }
}
