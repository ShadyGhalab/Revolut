//
//  URLSessionMock.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
@testable import Revolut

struct URLSessionMock: URLSessionRequesting {
   
    let shouldError: Bool
    let error: FetchError
    let expectedData: Data
    let sessionDataTask = URLSession.shared.dataTask(with: URL(string: "https://www.revolut.com")!)
    let response: HTTPURLResponse?
    
    init(shouldError: Bool = false, withError error: FetchError = .noContentReturned, expectedData: Data = Data(), response: HTTPURLResponse? = HTTPURLResponse()) {
        self.shouldError = shouldError
        self.error = error
        self.expectedData = expectedData
        self.response = response
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard !shouldError else {
            completionHandler(nil, response, error)
            
            return sessionDataTask
        }
        
        completionHandler(expectedData, nil, nil)
        
        return sessionDataTask
    }
}

extension FetchError: Equatable {
    public static func == (lhs: FetchError, rhs: FetchError) -> Bool {
        switch (lhs, rhs) {
        case (.noContentReturned, .noContentReturned):
            return true
        case (.httpError(statusCode: let lhsStatusCode), .httpError(statusCode: let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.fatal, .fatal):
            return true
        case (.nonFatal, .nonFatal):
            return true
        default:
            return false
        }
    }
}
