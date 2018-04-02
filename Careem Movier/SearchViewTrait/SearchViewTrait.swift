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
    var searchBarIsActive: Bool {get set}
    func searchViewAwakeFromNib()
    func searchViewDidLoad()
    func searchViewDidAppear()
    func searchViewNumberOfRows() -> Int
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell
    func searchViewDidSelectRowAt(_ indexPath: IndexPath)
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
        var numberOfRows = 0
        if searchBarIsActive {
            numberOfRows = interactor.suggestionQueries.count
        } else {
            numberOfRows = interactor.searchResponse?.results?.count ?? 0
        }
        let noMovies = NSLocalizedString("No Movies", comment: "A tableView background label indicating no movies")
        tableView.setBackgroundLabel(count: numberOfRows, text: noMovies)
        return numberOfRows
    }
    func searchViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        if searchBarIsActive {
            let suggestionCell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
            suggestionCell.configure(interactor.suggestionQueries[indexPath.row])
            return suggestionCell
        } else {
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            resultCell.configure(interactor.searchResponse!.results![indexPath.row])
            if shouldLoadMore(indexPath) {
                interactor.loadMore()
                startActivityIndicator()
            }
            return resultCell
        }
    }
    func searchViewDidSelectRowAt(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SuggestionCell else {return} // Only respond to SuggestionCell
        guard let searchBar = navigationItem.searchController?.searchBar else {return}
        tableView.deselectRow(at: indexPath, animated: false)
        startSearch(searchBar, cell.suggestionText)
    }
    
    // MARK: - UISearchBarDelegate
    func searchViewSearchButtonClicked(_ searchBar: UISearchBar) {
        /* Basically we will get searchBar text for sure because iOS's Search Button is auto enabled only when there are texts.
        But the safer the better.*/
        guard let text = searchBar.text, !text.isEmpty else {
            print("No String Entered")
            searchBar.resignFirstResponder()
            return
        }
        startSearch(searchBar, text)
    }
    func searchViewSearchTextDidBeginEditing() {
        searchBarIsActive = true
        interactor.updateSuggestionQueries()
        tableView.reloadData()
    }
    func searchViewSearchCancelButtonClicked() {
        searchBarIsActive = false
        tableView.reloadData()
    }
    
    // MARK: - UISearchControllerDelegate
    func searchViewDidPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {searchController.searchBar.becomeFirstResponder()}
    }
    
    // MARK: - Private Methods
    private func startSearch(_ searchBar: UISearchBar, _ text: String) {
        searchBar.resignFirstResponder()
        searchBarIsActive = false
        let request = SearchRequest(text: text, page: 1, successHandler: successHandler, errorHandler: errorHandler)
        interactor.search(request: request)
        startActivityIndicator()
    }
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
