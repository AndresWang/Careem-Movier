//
//  Extensions.swift
//  Careem Movier
//
//  Created by Andres Wang on 2018/3/31.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

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

