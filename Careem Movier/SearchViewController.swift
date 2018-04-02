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
    var activityView: UIVisualEffectView?
    var searchBarIsActive = false

    // MARK: - View LifeCyle
    override func awakeFromNib() {
        super.awakeFromNib()
        searchViewAwakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewDidAppear()
    }
    
    // MARK: - UITableView DataSource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewNumberOfRows()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return searchViewCellForRow(at: indexPath)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewSearchButtonClicked(searchBar)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchViewSearchTextDidBeginEditing()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewSearchCancelButtonClicked()
    }
    
    // MARK: - UISearchControllerDelegate
    func didPresentSearchController(_ searchController: UISearchController) {
        searchViewDidPresentSearchController(searchController)
    }
}

