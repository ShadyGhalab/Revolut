//
//  RequestManagerTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class RequestManagerTests: XCTestCase {
  
    let absolutePath = "https://www.revolut.com"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestingCurrencyRatesFeedResponse_whenTheRequestIsSucceed() {
        var expectedData: Data!
        
        do {
            expectedData = try JSONSerialization.data(withJSONObject: ["USDGBP": 0.7897000], options: .prettyPrinted)
        } catch  {
            XCTFail("Failed to archived Data")
        }
        
        let urlSessionMock: URLSessionRequesting = URLSessionMock(expectedData: expectedData)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let requestManager: CanRequestFeeds = RequestManager(dataRequester: dataRequester)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseValue: CurrencyRatesFeed.JSONResponseStructure!
        requestManager.request(from: currencyRatesFeed) {
            switch $0 {
            case .success(let value):
                responseValue = value
            case .failure(_):
                XCTFail("Shouldn't have called")
            }
        }
        
        XCTAssertEqual(responseValue, ["USDGBP": 0.7897000])
    }
    
    func testRequestingCurrencyRatesFeed_whenResponseIsFailedToDecode() {
        var expectedData: Data!
        
        do {
            expectedData = try JSONSerialization.data(withJSONObject: ["USDGBP": "0.7897000"], options: .prettyPrinted)
        } catch  {
            XCTFail("Failed to archived Data")
        }
        
        let urlSessionMock: URLSessionRequesting = URLSessionMock(expectedData: expectedData)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let requestManager: CanRequestFeeds = RequestManager(dataRequester: dataRequester)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        requestManager.request(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .noContentReturned)
    }
    
    func testRequestingCurrencyRatesFeedResponse_whenTheRequestIsFailedWithHttpError() {
        let response = HTTPURLResponse(url: URL(string: absolutePath)!, statusCode: 404, httpVersion: nil, headerFields: nil)
        let urlSessionMock: URLSessionRequesting = URLSessionMock(shouldError: true, withError: .noContentReturned, response: response)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let requestManager: CanRequestFeeds = RequestManager(dataRequester: dataRequester)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        requestManager.request(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .httpError(statusCode: 404))
    }
    
    func testRequestingCurrencyRatesFeedResponse_whenTheRequestIsFailedWitNonFatalError() {
        let urlSessionMock: URLSessionRequesting = URLSessionMock(shouldError: true, withError: .nonFatal)
        let dataRequester: DataRequesting = DataRequester(urlSession: urlSessionMock)
        let requestManager: CanRequestFeeds = RequestManager(dataRequester: dataRequester)
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var responseError: FetchError!
        requestManager.request(from: currencyRatesFeed) {
            switch $0 {
            case .success(_):
                XCTFail("Shouldn't have called")
            case .failure(let error):
                responseError = error
            }
        }
        
        XCTAssertEqual(responseError, .noContentReturned)
    }
}
