//
//  SearchViewTrait.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

// Note: SearchViewTrait and its extension not noly make our SearchViewController extremely light, but also make its code shareable for all UITableViewControllers. This is protocol oriented programming's composition. I prefer composition over inheritance, because it is much more flexible. I used this technique in my own project because I have four UITableViewControllers which need the same essential funtionality, but each view still can has its own specialties.
protocol SearchViewTrait: UISearchControllerDelegate, UISearchBarDelegate, ActivityIndicatable {
    var interactor: SearchInteractorDelegate! {get set}
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 167
        title = NSLocalizedString("Search", comment: "Big nav title")
        
        // Add UISearchController
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
    
    // MARK: - UITableView DataSource & Delegate
    func searchViewNumberOfRows() -> Int {
        let numberOfRows = interactor.searchResponse?.results?.count ?? 0
        return numberOfRows
    }
    func searchViewCellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        resultCell.configure(interactor.searchResponse!.results![indexPath.row])
        if shouldLoadMore(indexPath) {
            interactor.loadMore()
            startActivityIndicator()
        }
        return resultCell
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        // Basically we will get searchBar text for sure because iOS's Search Button is auto enabled only when there are texts. But the safer the better.
        guard let text = searchBar.text, !text.isEmpty else {print("No String Entered");searchBar.resignFirstResponder();return}
        searchBar.resignFirstResponder()
        
        let request = SearchRequest(text: text, page: 1, successHandler: successHandler, errorHandler: errorHandler)
        interactor.search(request: request)
        startActivityIndicator()
    }
    
    // MARK: - UISearchControllerDelegate
    func searchViewDidPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
    
    // MARK: - Private Methods
    private func successHandler(searchText: String?, isLoadMore: Bool) {
        endSearch()
        
        guard isLoadMore == false else {return}
        if let text = searchText {
            interactor.saveSuccessfulQuery(searchText: text)
        } else {
            showNothingFoundError()
        }
    }
    private func errorHandler() {
        endSearch()
        showNetworkError()
    }
    private func endSearch() {
        stopActivityIndicator()
        tableView.reloadData()
        navigationItem.searchController?.isActive = false
    }
    private func shouldLoadMore(_ indexPath: IndexPath) -> Bool {
        guard let searchResponse = interactor.searchResponse, let results = searchResponse.results, activityView == nil else {return false}
        return indexPath.row == results.count - 1 && searchResponse.total_pages > searchResponse.page
    }
}
