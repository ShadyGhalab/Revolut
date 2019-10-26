//
//  CurrencyPairTableViewSnapshotsTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
import CoreData
@testable import Revolut

class CurrencyPairTableViewSnapshotsTests: FBSnapshotTestCase {
    private var window: UIWindow = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    var currencyPair: CurrencyPair!
    var viewContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()

        fileNameOptions = [.device, .OS, .screenSize]

        viewContext = AppDelegate.shared.persistentContainer.viewContext
        currencyPair = CurrencyPair.make(with: viewContext,
                                         fromCurrencyCode: "CZK",
                                         toCurrencyCode: "USD",
                                         fromCurrencyName: "Czech Koruna ",
                                         toCurrencyName: "United States Dollar")
        
        viewContext.saveContext()
    }
    
    func testCurrencyPairTableViewCell() {
        
        let view = CurrencyPairTableViewCell.loadFromNib()
        let frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 136)
        view.frame = frame
        
        window.addSubview(view)
        window.makeKeyAndVisible()
        
        let timerExpectation = expectation(description: "Request currency rates with time")
        let mockedRequestManager = MockedRequestManager()
        mockedRequestManager.currencyRatesFeedExpectedData = ["USDGBP": 0.7897000]
        let currencyPairRateProvider = CurrencyPairRateProvider(requestManager: mockedRequestManager)
        let viewModel = CurrencyPairCellViewModel(currencyPair: currencyPair, currencyPairRateProvider: currencyPairRateProvider, timerRepeats: false)
        
        view.viewModel = viewModel
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                  timerExpectation.fulfill()
              }
              
        waitForExpectations(timeout: 3) { [unowned self ] _ in
            self.FBSnapshotVerifyView(self.window)
        }
        
    }
}
