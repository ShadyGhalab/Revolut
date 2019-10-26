//
//  CurrencyPairTableViewDataSourceTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
import CoreData
@testable import Revolut

class CurrencyPairTableViewDataSourceTests: XCTestCase {
    
    private var dataSource: CurrencyPairTableViewDataSource!
    
    override func setUp() {
        dataSource = CurrencyPairTableViewDataSource(fetchedResultController: FetchedResultsControllerMock())
    }
    
    func testValueInDataSource() {
        
        let tableView = UITableView(frame: UIScreen.main.bounds)
        
        tableView.dataSource = dataSource
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
}

private class FetchedResultsControllerMock: NSFetchedResultsController<CurrencyPair> {
    override var sections: [NSFetchedResultsSectionInfo]? {
        return [SectionInfo()]
    }
}

private class SectionInfo: NSFetchedResultsSectionInfo {
    var name: String = "SectionInfo"
    var indexTitle: String?
    var numberOfObjects: Int = 2
    var objects: [Any]?
}
