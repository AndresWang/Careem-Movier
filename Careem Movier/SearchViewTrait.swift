//
//  SearchViewTrait.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewTrait: UISearchControllerDelegate, UISearchBarDelegate {
    var interactor: SearchInteractorDelegate {get}
}
