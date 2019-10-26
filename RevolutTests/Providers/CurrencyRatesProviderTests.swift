//
//  CurrencyRatesProviderTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class CurrencyRatesProviderTests: XCTestCase {
    
    func testCurrencyRates_whenTheRequestIsSucceed() {
        let mockedRequestManager = MockedRequestManager()
        mockedRequestManager.currencyRatesFeedExpectedData = ["USDGBP": 0.7897]
        
        let currencyPairRateProvider: CurrencyPairRateProviding = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        
        currencyPairRateProvider.rate(fromCurrencyCode: "CZK", toCurrencyCode: "USD") { value in
            XCTAssertEqual(value?.first?.value, 0.7897)
        }
    }
    
    func testCurrencyRates_whenTheRequestIsFailed() {
        let mockedRequestManager = MockedRequestManager(shouldError: true)
        
        let currencyPairRateProvider: CurrencyPairRateProviding = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        
        currencyPairRateProvider.rate(fromCurrencyCode: "CZK", toCurrencyCode: "USD") { value in
            XCTAssertNil(value?.first?.value)
        }
    }
}
