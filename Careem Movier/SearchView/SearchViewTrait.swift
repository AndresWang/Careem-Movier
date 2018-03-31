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
    var searchResultCellIdentifier: String {get}
    func hookUpComponentsAfterAwakeFromNib()
}

extension SearchViewTrait where Self: UITableViewController {
    func hookUpComponentsAfterAwakeFromNib() {
        let interactor: SearchInteractorDelegate = SearchInteractor()
        interactor.setUpAPI()
        self.interactor = interactor
    }
}
