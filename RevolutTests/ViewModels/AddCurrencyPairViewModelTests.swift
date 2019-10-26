//
//  AddCurrencyPairViewModelTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class AddCurrencyPairViewModelTests: XCTestCase {
    
    func testCurrenciesData_whenTheJsonFileIsNotEmpty() {
        let currencyProvider = CurrencyProvider(resourceName: "TestCurrenciesData", bundle: Bundle(for: AddCurrencyPairViewModelTests.self))
        let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel(currencyProvider: currencyProvider)
        
        XCTAssertEqual(viewModel.outputs.currencies.first?.name, "Pound sterling")
        XCTAssertEqual(viewModel.outputs.currencies.first?.imageName, "UK")
        XCTAssertEqual(viewModel.outputs.currencies.first?.code, "GBP")
        
        XCTAssertEqual(viewModel.outputs.currencies.last?.name, "United States Dollar")
        XCTAssertEqual(viewModel.outputs.currencies.last?.imageName, "US")
        XCTAssertEqual(viewModel.outputs.currencies.last?.code, "USD")
    }
    
    func testCurrenciesCount_whenTheJsonFileHasCurrenciesData() {
        let currencyProvider = CurrencyProvider(resourceName: "TestCurrenciesData", bundle: Bundle(for: AddCurrencyPairViewModelTests.self))
        let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel(currencyProvider: currencyProvider)
        
        XCTAssertTrue(viewModel.outputs.currencies.count == 2)
    }
    
    func testCurrenciesCount_whenTheJsonFileIsEmpty() {
        let currencyProvider = CurrencyProvider(resourceName: "TestEmptyCurrenciesData", bundle: Bundle(for: AddCurrencyPairViewModelTests.self))
        let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel(currencyProvider: currencyProvider)
        
        XCTAssertTrue(viewModel.outputs.currencies.count == 0)
    }
    
    func testTitleLabelLocalizedText() {
        let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel()
        
        XCTAssertEqual(viewModel.outputs.titleLabelLocalizedText, "Add currency pair")
    }
    
    func testDescriptionLabelLocalizedText() {
        let viewModel: AddCurrencyPairViewProtocol = AddCurrencyPairViewModel()
        
        XCTAssertEqual(viewModel.outputs.descriptionLabelLocalizedText, "Choose a currency pair to compare their live rates")
    }
}
