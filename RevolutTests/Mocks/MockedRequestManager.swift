//
//  MockedRequestManager.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 24.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
@testable import Revolut

final class MockedRequestManager: CanRequestFeeds {
  
    let shouldError: Bool
    var currencyRatesFeedExpectedData: [String : Double]?
    
    init(shouldError: Bool = false) {
        self.shouldError = shouldError
    }
    
    func request<F: Feed>(from feed: F, completionHandler: @escaping (Result<F.JSONResponseStructure, FetchError>) -> Void) {
        guard !shouldError else { return completionHandler(.failure(.noContentReturned))}
        
        if feed is CurrencyRatesFeed {
            completionHandler(.success(currencyRatesFeedExpectedData as! F.JSONResponseStructure))
        }
    }
}
 
