//
//  DataResponseDecoderTests.swift
//  RevolutTests
//
//  Created by Shady Mustafa on 25.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import XCTest
@testable import Revolut

class DataResponseDecoderTests: XCTestCase {
   
    let absolutePath = "https://www.revolut.com"
    
    func testDecodeJSSON_whenTheJsonIsValid() {
        let dataResponseDecoder: DataResponseDecoding = DataResponseDecoder()
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        var expectedData: Data!
        
        do {
            expectedData = try JSONSerialization.data(withJSONObject: ["USDGBP": 0.7897000], options: .prettyPrinted)
        } catch  {
            XCTFail("Failed to archived Data")
        }
        
        XCTAssertNoThrow(try dataResponseDecoder.decodeJson(from: currencyRatesFeed, with: expectedData))
        XCTAssertEqual(try dataResponseDecoder.decodeJson(from: currencyRatesFeed, with: expectedData), ["USDGBP": 0.7897000])
    }
    
    func testDecodeJSON_whenTheJsonIsInvalid() {
        var expectedData: Data!
        
        do {
            expectedData = try JSONSerialization.data(withJSONObject: ["USDGBP": "0.7897000"], options: .prettyPrinted)
        } catch  {
            XCTFail("Failed to archived Data")
        }
        
        let dataResponseDecoder: DataResponseDecoding = DataResponseDecoder()
        let currencyRatesFeed = CurrencyRatesFeed(absolutePath: absolutePath, parameters: [["pairs": "USDGBP"]])
        
        XCTAssertThrowsError(try dataResponseDecoder.decodeJson(from: currencyRatesFeed, with: expectedData))
    }
}
