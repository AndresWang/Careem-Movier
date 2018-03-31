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
    var nothingFoundCellIdentifier = "NothingFoundCell"
    var loadingCellIdentifier = "LoadingCell"
    var hasSearched = false
    var isLoading = false

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
}

