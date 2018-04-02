//
//  SuggestionCell.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/4/2.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
    @IBOutlet weak private var suggestionName: UILabel!
    
    // MARK: - Boundary Methods
    func configure(_ text: String) {
        suggestionName.text = text
    }
    var suggestionText: String {
        return suggestionName.text!
    }
}
