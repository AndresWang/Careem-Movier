//
//  Extensions.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import UIKit

// Note: A generic function for parsing data to all type of json struct
extension Data {
    func parseTo<T: Codable>(jsonType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(jsonType, from: self)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
}

extension UIViewController {
    func showNetworkError() {
        let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Network error title"), message: NSLocalizedString("There was an error accessing Moviedb database. Please try again.", comment: "Network error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Button"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showNothingFoundError() {
        let alert = UIAlertController(title: NSLocalizedString("Sorry...", comment: "Nothing found error title"), message: NSLocalizedString("Nothing found in our database. Please try other names.", comment: "Nothing found error message"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Button"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] localURL, response, error in
            if error == nil, let localURL = localURL, let data = try? Data(contentsOf: localURL), let image = UIImage(data: data) {
                DispatchQueue.main.async { if let weakSelf = self {weakSelf.image = image}}
            } else {
                print("Something wrong with downloading the image")
            }
        }
        downloadTask.resume()
        return downloadTask
    }
    func rounded() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}

