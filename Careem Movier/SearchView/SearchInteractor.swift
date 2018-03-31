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
}
class SearchInteractor: SearchInteractorDelegate {
    private var api: APIDelegate?
    private(set) var response: Movie.Response?
}
extension SearchInteractor: APIOutputDelegate {
    func didRecieveResponse(data: Data?, response: URLResponse?, error: Error?) {
        
    }
}
