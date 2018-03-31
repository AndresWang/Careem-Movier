//
//  ActivityIndicatable.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityIndicatable: class {
    var activityView: UIVisualEffectView? {get set}
}

extension ActivityIndicatable {
    func stopActivityIndicator() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}
