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

    override func awakeFromNib() {
        super.awakeFromNib()
        hookUpComponentsAfterAwakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

