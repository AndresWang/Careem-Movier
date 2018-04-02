//
//  SearchInteractor.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: SearchInteractor is the domain object for SearchViewTrait, a manager for all data manipulations, normally it will delegate tasks to database or api worker for fetching data and report the result to its viewController. We use SearchInteractorDelegate as interface just in case we may change our domain object. This interface is searchViewTrait's viewcontroller's only output.
protocol SearchInteractorDelegate: APIOutputDelegate {
    var searchResponse: Movie.Response? {get}
    var suggestionQueries: [String] {get}
    func configure()
    func search(request: SearchRequest)
    func saveSuccessfulQuery(searchText: String)
    func loadMore()
    func updateSuggestionQueries()
}
class SearchInteractor: SearchInteractorDelegate {
    private(set) var searchResponse: Movie.Response?
    private(set) var suggestionQueries: [String] = []
    private var api: APIDelegate!
    private var dataStore: DataStoreDelegate!
    private var searchRequest: SearchRequest?
    private var isLoadMore = false
    
    // MARK: - SearchInteractorDelegate
    func configure() {
        self.api = MoviedbAPI(output: self)
        self.dataStore = CoreDataStore.sharedInstance
    }
    func search(request: SearchRequest) {
        isLoadMore = false
        self.searchRequest = request
        let url = MoviedbAPI.searchURL(with: request.text, page: request.page)
        api.startDataTask(url: url)
    }
    func saveSuccessfulQuery(searchText: String) {
        dataStore.saveSuccessfulQuery(text: searchText)
    }
    func loadMore() {
        isLoadMore = true
        searchRequest?.page += 1
        let url = MoviedbAPI.searchURL(with: searchRequest!.text, page: searchRequest!.page)
        api.startDataTask(url: url)
    }
    func updateSuggestionQueries() {
        suggestionQueries = dataStore.fetchSuggestionQueries().map{$0.text}
    }
    
    // MARK: - APIOutputDelegate
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error as NSError?, error.code == -999 {
            print("URLSession's task was cancelled -> Handled silently")
            return
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let data = data {
                process(data)
                return /* Exit */
            }
        } else {
            print("URLSession Failure! \(String(describing: response)) -> Passed to our error handler")
        }
        
        // Handle errors
        DispatchQueue.main.async {self.searchRequest?.errorHandler()}
    }
    
    // MARK: - Private Methods
    private func process(_ data: Data) {
        if isLoadMore {
            guard let newResults = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.toMovie().results else {return}
            searchResponse?.page += 1
            searchResponse?.results?.append(contentsOf: newResults)
        } else {
            searchResponse = data.parseTo(jsonType: MoviedbAPI.JSON.Response.self)?.toMovie()
        }
        let resultCount = searchResponse?.results?.count ?? 0
        let searchText = resultCount > 0 ? searchRequest!.text : nil
        DispatchQueue.main.async {self.searchRequest?.successHandler(searchText, self.isLoadMore)}
    }
}
