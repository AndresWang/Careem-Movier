//
//  ActivityIndicatable.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/4/1.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityIndicatable: class {
    var activityView: UIVisualEffectView? {get set}
}

extension ActivityIndicatable where Self: UIViewController {
    func startActivityIndicator() {
        activityView = view.showActivityPanel(message: NSLocalizedString("Loading...", comment: "Network working"))
    }
    func stopActivityIndicator() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}
