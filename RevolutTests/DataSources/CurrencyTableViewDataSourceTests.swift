//
//  CurrencyTableViewDataSourceTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class CurrencyTableViewDataSourceTests: XCTestCase {
    
    private var dataSource: CurrencyTableViewDataSource!
    
    override func setUp() {
        dataSource = CurrencyTableViewDataSource(currencies: [Currency.make()])
    }
    
    func testValueInDataSource() {
        
        let tableView = UITableView(frame: UIScreen.main.bounds)
        
        tableView.dataSource = dataSource
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    }
}
