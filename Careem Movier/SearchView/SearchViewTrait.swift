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
protocol SearchViewTrait: UISearchControllerDelegate, UISearchBarDelegate, ActivityIndicatable {
    var interactor: SearchInteractorDelegate! {get set}
    var searchResultCellIdentifier: String {get}
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
        interactor.configure()
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
    }
    func searchViewDidAppear() {
        // Call keyboard up only for first time
        guard interactor.searchResponse == nil else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {self.navigationItem.searchController?.isActive = true}
    }
    
    // MARK: - UITableView DataSource
    func searchViewNumberOfRows() -> Int {
        guard let response = interactor.searchResponse, let results = response.results, results.count > 0 else {return 0}
        return results.count
    }
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath) as! SearchResultCell
        resultCell.configure(interactor.searchResponse!.results![indexPath.row])
        return resultCell
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        // Basically We will get searchBar text for sure because iOS's Search Button is auto enabled only when there are texts.
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        searchBar.resignFirstResponder()
        
        let request = SearchRequest(text: text, page: 1, successHandler: successHandler, errorHandler: errorHandler)
        startActivityIndicator()
        interactor.search(request: request)
    }
    
    // MARK: - UISearchControllerDelegate
    func searchViewDidPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
    
    // MARK: - Private Methods
    private func successHandler(searchText: String?) {
        stopActivityIndicator()
        endSearch()
        if let text = searchText {
            interactor.saveSuccessfulQuery(searchText: text)
        } else {
            showNothingFoundError()
        }
    }
    private func errorHandler() {
        stopActivityIndicator()
        endSearch()
        showNetworkError()
    }
    private func endSearch() {
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
    }
}
