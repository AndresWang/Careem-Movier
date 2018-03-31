//
//  SearchViewTrait.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

// Note: SearchViewTrait and its extension not noly make our searchViewController extremely light, but also make its code shareable for all UITableViewControllers. This is protocol oriented programming's composition. I prefer composition over inheritance, because it is much more flexible. I used this technique in my own project because I have four UITableViewControllers which need the same essential funtionality, but each view still has its own specialties.
protocol SearchViewTrait: UISearchControllerDelegate, UISearchBarDelegate {
    var interactor: SearchInteractorDelegate! {get set}
    var isLoading: Bool {get set}
    var searchResultCellIdentifier: String {get}
    var loadingCellIdentifier: String {get}
    func searchViewAwakeFromNib()
    func searchViewDidLoad()
    func searchViewDidAppear()
    func searchViewNumberOfRows() -> Int
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar)
    func searchViewDidPresentSearchController(_ searchController: UISearchController)
}

extension SearchViewTrait where Self: UITableViewController {
    // MARK: - View Life Cycle
    func searchViewAwakeFromNib() {
        // Hook up all components
        let interactor: SearchInteractorDelegate = SearchInteractor()
        interactor.setUpAPI()
        self.interactor = interactor
    }
    func searchViewDidLoad() {
        // TableView Setups
        tableView.rowHeight = 80
        title = NSLocalizedString("Search", comment: "Big nav title")
        
        // Add SearchBar
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.delegate = self
        search.searchBar.placeholder = NSLocalizedString("Movie Name", comment: "A placeholder to search movie" )
        navigationItem.searchController = search
        search.searchBar.accessibilityIdentifier = "mySearchBar"
        
        // Register Nibs
        let loadingCellNib = UINib(nibName: loadingCellIdentifier, bundle: nil)
        tableView.register(loadingCellNib, forCellReuseIdentifier: loadingCellIdentifier)
    }
    func searchViewDidAppear() {
        // Call keyboard up only for first time
        guard interactor.response == nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {self.navigationItem.searchController?.isActive = true}
    }
    
    // MARK: - UITableView DataSource
    func searchViewNumberOfRows() -> Int {
        if isLoading {return 1}
        guard let response = interactor.response, let results = response.results, results.count > 0 else {return 0}
        return results.count
    }
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath)
            let spinner = loadingCell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return loadingCell
        }
        
        let resultCell = tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath) as! SearchResultCell
        resultCell.configure(interactor.response!.results![indexPath.row])
        return resultCell
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        searchBar.resignFirstResponder()
        tableView.contentOffset = .zero
        isLoading = true
        tableView.reloadData()
        let request = SearchRequest(text: text, page: 1, successHandler: successHandler, errorHandler: errorHandler)
        interactor.search(request: request)
    }
    
    // MARK: - UISearchControllerDelegate
    func searchViewDidPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
    
    // MARK: - Private Methods
    private func successHandler(hasResults: Bool) {
        isLoading = false
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
        if hasResults == false {showNothingFoundError()}
    }
    private func errorHandler() {
        isLoading = false
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
        showNetworkError()
    }
}
