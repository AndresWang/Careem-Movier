//
//  SearchInteractor.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

// Note: SearchInteractor is the domain object for SearchViewTrait, a manager for all data manipulations, normally it will ask database or api worker for data and report the result to its viewController. But we use SearchInteractorDelegate as interface just in case we may change our domain object. This interface is searchViewTrait's viewcontroller's only output.
protocol SearchInteractorDelegate {
    
}
class SearchInteractor: SearchInteractorDelegate {
    
}
