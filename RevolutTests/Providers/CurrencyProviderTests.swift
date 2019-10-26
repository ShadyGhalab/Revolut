//
//  CurrencyProviderTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class CurrencyProviderTests: XCTestCase {
    
    func testAllCurrenciesData_whenTheJsonFileIsNotEmpty() {
        let currencyProvider: CurrencyProviding = CurrencyProvider(resourceName: "TestCurrenciesData", bundle: Bundle(for: AddCurrencyPairViewModelTests.self))
        
        XCTAssertTrue(currencyProvider.currencies().count == 2)
    }
    
    func testAllCurrenciesData_whenTheJsonFileIsEmpty() {
        let currencyProvider: CurrencyProviding = CurrencyProvider(resourceName: "TestEmptyCurrenciesData", bundle: Bundle(for: AddCurrencyPairViewModelTests.self))
        
        XCTAssertTrue(currencyProvider.currencies().isEmpty)
    }
}
