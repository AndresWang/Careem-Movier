//
//  SearchInteractor.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: SearchInteractor is the domain object for SearchViewTrait, a manager for all data manipulations, normally it will ask database or api worker for data and report the result to its viewController. We use SearchInteractorDelegate as interface just in case we may change our domain object. This interface is searchViewTrait's viewcontroller's only output.
protocol SearchInteractorDelegate {
    var response: Movie.Response? {get}
    func setUpAPI()
    func search(request: SearchRequest)
}
class SearchInteractor: SearchInteractorDelegate {
    private var api: APIDelegate!
    private(set) var response: Movie.Response?
    private var searchRequest: SearchRequest?
    
    func setUpAPI() {
        self.api = MoviedbAPI(output: self)
    }
    func search(request: SearchRequest) {
        self.searchRequest = request
        let url = MoviedbAPI.searchURL(with: request.text, page: request.page)
        api.startDataTask(url: url)
    }
}

// MARK: - APIOutputDelegate
extension SearchInteractor: APIOutputDelegate {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error as NSError?, error.code == -999 {
            return // Task was cancelled
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                self.process(data)
                DispatchQueue.main.async {self.searchRequest?.successHandler()}
                return /* Exit the closure */
            }
        } else {
            print("URLSession Failure! \(String(describing: response))")
        }
        
        // Handle errors
        DispatchQueue.main.async {self.searchRequest?.errorHandler()}
    }
    
    // MARK: Private Methods
    private func process(_ data: Data) {
        response = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.toMovie()
    }
}
