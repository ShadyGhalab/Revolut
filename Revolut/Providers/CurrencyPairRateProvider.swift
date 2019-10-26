//
//  CurrencyRatesProvider.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

protocol CurrencyPairRateProviding {
    func rates(fromCurrencyCode: String?, toCurrencyCode: String?, completionHandler: @escaping (CurrencyRatesFeed.JSONResponseStructure?) -> Void)
}

struct CurrencyPairRateProvider: CurrencyPairRateProviding {

    private let requestManager: CanRequestFeeds
    private let absolutePath: String

    init( requestManager: CanRequestFeeds = RequestManager(), absolutePath: String = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios") {
        self.requestManager = requestManager
        self.absolutePath = absolutePath
    }

    func rates(fromCurrencyCode: String?, toCurrencyCode: String?, completionHandler: @escaping (CurrencyRatesFeed.JSONResponseStructure?) -> Void) {
        guard let fromCurrencyCode = fromCurrencyCode, let toCurrencyCode = toCurrencyCode else {
            completionHandler(nil)
            return
        }

        let pairCode = fromCurrencyCode + toCurrencyCode
        let feed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": pairCode]])

        requestManager.request(from: feed) {
            switch $0 {
            case .success(let value):
                completionHandler(value)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }
}
