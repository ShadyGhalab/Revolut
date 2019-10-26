//
//  CurrencyPairCellViewModelTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class CurrencyPairCellViewModelTests: XCTestCase {
    
    var currencyPair: CurrencyPair!
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        viewContext = AppDelegate.shared.persistentContainer.viewContext
        currencyPair = CurrencyPair.make(with: viewContext,
                                         fromCurrencyCode: "CZK",
                                         toCurrencyCode: "USD",
                                         fromCurrencyName: "Czech Koruna ",
                                         toCurrencyName: "United States Dollar")
        
        viewContext.saveContext()
    }
    
    func testFetchingCurrencyRatesWithTimer_whenTheRequestIsSucceed() {
        let timerExpectation = expectation(description: "Request currency rates with time")
        
        let mockedRequestManager = MockedRequestManager()
        mockedRequestManager.currencyRatesFeedExpectedData = ["USDGBP": 0.7897000]
        
        let currencyPairRateProvider = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        let viewModel = CurrencyPairCellViewModel(currencyPair: currencyPair, currencyPairRateProvider: currencyPairRateProvider, timerRepeats: false)
        
        var currencyRate = ""
        viewModel.outputs.updateCurrencyRateIfNeeded = { rate in
            currencyRate = rate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            timerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(currencyRate, "0.7897")
        }
    }
    
    func testFetchingCurrencyRatesWithTimer_whenTheRequestIsFailed() {
        let timerExpectation = expectation(description: "Request currency rates with time")
        
        let mockedRequestManager = MockedRequestManager(shouldError: true)
        
        let currencyPairRateProvider = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        let viewModel = CurrencyPairCellViewModel(currencyPair: currencyPair, currencyPairRateProvider: currencyPairRateProvider, timerRepeats: false)
        
        var currencyRate = ""
        viewModel.outputs.updateCurrencyRateIfNeeded = { rate in
            currencyRate = rate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            timerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(currencyRate, "")
        }
    }
    
    func testCurrencyRatesIsRoundedToTheLastFourDeceimalDigitsOnly() {
        let timerExpectation = expectation(description: "Request currency rates with time")
        
        let mockedRequestManager = MockedRequestManager()
        mockedRequestManager.currencyRatesFeedExpectedData = ["USDGBP": 0.7897888]
        
        let currencyPairRateProvider = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        let viewModel = CurrencyPairCellViewModel(currencyPair: currencyPair, currencyPairRateProvider: currencyPairRateProvider, timerRepeats: false)
        
        var currencyRate = ""
        viewModel.outputs.updateCurrencyRateIfNeeded = { rate in
            currencyRate = rate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            timerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(currencyRate, "0.7898")
        }
    }
    
    override func tearDown() {
        viewContext.delete(currencyPair)
        viewContext.saveContext()
      
        super.tearDown()
    }
}
