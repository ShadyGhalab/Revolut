//
//  Configuration.swift
//  Revolut
//
//  Created by Shady Mustafa on 26.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

enum ServerEnvironment: String {
    case development, staging, production
}

struct Configuration {
    let backendEnvironment: ServerEnvironment

    //swiftlint:disable force_unwrapping
    var backendURL: URL {
        switch backendEnvironment {
        case .development: return URL(string: "https://dev-europe-west1-revolut-230009.cloudfunctions.net")!
        case .staging: return URL(string: "https://qa-europe-west1-revolut-230009.cloudfunctions.net")!
        case .production: return URL(string: "https://europe-west1-revolut-230009.cloudfunctions.net")!
        }
    }
    //swiftlint:enable force_unwrapping
}
