//
//  RequestManager.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import os.log

enum FetchError: Error {
    case noContentReturned
    case httpError(statusCode: Int)
    case nonFatal
    case fatal
}

protocol CanRequestFeeds {
    func request<F: Feed>(from feed: F, completionHandler: @escaping (Result<F.JSONResponseStructure, FetchError>) -> Void)
}

struct RequestManager: CanRequestFeeds {

    private let dataRequester: DataRequesting
    private let responseDecoder: DataResponseDecoding

    init(dataRequester: DataRequesting = DataRequester(), responseDecoder: DataResponseDecoding = DataResponseDecoder()) {
        self.dataRequester = dataRequester
        self.responseDecoder = responseDecoder
    }

    func request<F: Feed>(from feed: F, completionHandler: @escaping (Result<F.JSONResponseStructure, FetchError>) -> Void) {
        dataRequester.requestData(from: feed) { result in
            switch result {
            case .success(let data):
                do {
                    let model = try self.responseDecoder.decodeJson(from: feed, with: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(.noContentReturned))
                }

            case .failure(let error):
                self.logDecodeError(error, from: feed)
                completionHandler(.failure(error))
            }
        }
    }

    private func logDecodeError<F: Feed>(_ error: Error, from feed: F) {
        switch error {
        case DataResponseDecodeError.decodeToJsonFailed:
            let type = "\(F.self)"
            os_log("Error trying to unwrap feed: %@", log: .requestsLogger, type: .error, type)
            os_log("URL was: %@", log: .requestsLogger, type: .error, feed.absolutePath)
        default:
            let type = "\(F.self)"
            os_log("Error trying to decode %@: %@", log: .requestsLogger, type: .error, type, error.localizedDescription)
            os_log("URL was: %@", log: .requestsLogger, type: .error, feed.absolutePath)
        }
    }
}
