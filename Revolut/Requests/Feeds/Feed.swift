//
//  Feede.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

protocol Feed {
    associatedtype JSONResponseStructure

    var absolutePath: String { get }
    var parameters: [[String: Any]]? { get }
    var customDateFormat: String? { get }
}

extension Feed {
    var customDateFormat: String? { return nil }
}
