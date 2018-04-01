//
//  SearchInteractor.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: SearchInteractor is the domain object for SearchViewTrait, a manager for all data manipulations, normally it will ask database or api worker for data and report the result to its viewController. We use SearchInteractorDelegate as interface just in case we may change our domain object. This interface is searchViewTrait's viewcontroller's only output.
protocol SearchInteractorDelegate: APIOutputDelegate {
    var searchResponse: Movie.Response? {get}
    func configure()
    func search(request: SearchRequest)
    func saveSuccessfulQuery(searchText: String)
}
class SearchInteractor: SearchInteractorDelegate {
    private var api: APIDelegate!
    private var dataStore: DataStoreDelegate!
    private var searchRequest: SearchRequest?
    private(set) var searchResponse: Movie.Response?
    
    // MARK: - Boundary Methods
    // MARK: SearchInteractorDelegate
    func configure() {
        self.api = MoviedbAPI(output: self)
        self.dataStore = CoreDataStore.sharedInstance
    }
    func search(request: SearchRequest) {
        self.searchRequest = request
        let url = MoviedbAPI.searchURL(with: request.text, page: request.page)
        api.startDataTask(url: url)
    }
    func saveSuccessfulQuery(searchText: String) {
        dataStore.saveSuccessfulQuery(text: searchText)
    }
    
    // MARK: APIOutputDelegate
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error as NSError?, error.code == -999 {
            return // Task was cancelled, should fail silently
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                searchResponse = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.toMovie()
                searchResponse?.results?.sort(by: newestFirst)
                let resultCount = searchResponse?.results?.count ?? 0
                let searchText = resultCount > 0 ? searchRequest!.text : nil
                DispatchQueue.main.async {self.searchRequest?.successHandler(searchText)}
                return /* Exit */
            }
        } else {
            print("URLSession Failure! \(String(describing: response))")
        }
        
        // Handle errors
        DispatchQueue.main.async {self.searchRequest?.errorHandler()}
    }
    
    // MARK: - Private Methods
    // Note: Search result always show newest movie at top
    private func newestFirst (lhs: Movie.Result, rhs: Movie.Result) -> Bool {
        let seventyYears: TimeInterval = 70 * 12 * 30 * 24 * 60 * 60
        let veryOldDate = Date(timeIntervalSince1970: -seventyYears)
        let lhsDate = lhs.release_date ?? veryOldDate
        let rhsDate = rhs.release_date ?? veryOldDate
        return lhsDate > rhsDate
    }
}
