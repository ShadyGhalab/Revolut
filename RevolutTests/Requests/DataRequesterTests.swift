//
//  DataRequesterTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class DataRequesterTests: XCTestCase {
   
    let absolutePath = "https://www.revolut.com"
    
    func testRequestingData_whenTheRequestIsSucceed() {
        var expectedData: Data!
        
        do {
            expectedData = try JSONSerialization.data(withJSONObject: ["USDGBP": 0.7897000], options: .prettyPrinted)
        } catch  {
            XCTFail("Failed to archived Data")
        }
        
        let urlSessionMock: URLSessionRequesting = URLSessionMock(expectedData: expectedData)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var fetchedData: Data!
        dataRequester.requestData(from: currencyRatesFeed) {
            switch $0 {
            case .success(let data):
                fetchedData = data
            case .failure(_):
                XCTFail("Shouldn't have called")
            }
        }
        
        XCTAssertEqual(fetchedData, expectedData)
    }
    
    func testRequestingData_whenTheRequestIsFailedWithNoContentReturnedError() {
        
        let urlSessionMock: URLSessionRequesting = URLSessionMock(shouldError: true, withError: .noContentReturned)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        dataRequester.requestData(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .noContentReturned)
    }
    
    func testRequestingData_whenTheRequestIsFailedWithHttpError() {
        let response = HTTPURLResponse(url: URL(string: absolutePath)!, statusCode: 404, httpVersion: nil, headerFields: nil)
        let urlSessionMock: URLSessionRequesting = URLSessionMock(shouldError: true, withError: .httpError(statusCode: 404), response: response)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        dataRequester.requestData(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .httpError(statusCode: 404))
    }
    
    func testRequestingData_whenTheRequestIsFailedWithNonFatalError() {
        let invalidAbsolutePath = "https:/ww.revolut.com"
        let urlSessionMock: URLSessionRequesting = URLSessionMock(shouldError: true, withError: .nonFatal)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: invalidAbsolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        dataRequester.requestData(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .nonFatal)
    }
}
