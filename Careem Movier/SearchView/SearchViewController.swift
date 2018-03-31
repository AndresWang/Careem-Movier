//
//  ViewController.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

// Note: SearchViewController is merely a coordinator between its interactor and its subviews.
class SearchViewController: UITableViewController, SearchViewTrait {
    var interactor: SearchInteractorDelegate!
    let searchResultCellIdentifier = "SearchResultCell"
    var activityView: UIVisualEffectView?
    var hasSearched = false
    var isLoading = false
    var selectedIndexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        hookUpComponentsAfterAwakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = SearchRequest(text: "batman", page: 1, prehandler: nil, successHandler: successHandler, errorHandler: errorHandler)
        interactor.search(request: request)
    }
    
    private func successHandler() {
        isLoading = false
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
    }
    private func errorHandler() {
        hasSearched = false
        isLoading = false
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
        showNetworkError()
    }
}

