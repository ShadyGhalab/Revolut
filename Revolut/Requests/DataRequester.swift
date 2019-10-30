//
//  DataRequester.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import os.log
import UIKit

private enum Constants {
    static let timeoutIntervalForRequest: TimeInterval = 29
    static let timeoutIntervalForResource: TimeInterval = 59
}

protocol DataRequesting {
    func requestData<F>(from feed: F, completionHandler: @escaping (Result<Data, FetchError>) -> Void) where F: Feed
}

protocol URLSessionRequesting {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    var timeoutIntervalForRequest: TimeInterval { get set }
    var timeoutIntervalForResource: TimeInterval { get set }
}

extension URLSession: URLSessionRequesting {
    var timeoutIntervalForRequest: TimeInterval {
        get { Constants.timeoutIntervalForRequest }
        set { }
    }

    var timeoutIntervalForResource: TimeInterval {
        get { Constants.timeoutIntervalForResource }
        set { }
    }
}

struct DataRequester: DataRequesting {

    private let urlSession: URLSessionRequesting

    init(urlSession: URLSessionRequesting = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }

    func requestData<F>(from feed: F, completionHandler: @escaping (Result<Data, FetchError>) -> Void) where F: Feed {
        let absolutePath = feed.absolutePath

        os_log("requesting feed %@ from %@ with override parameters: %@)",
               log: .requestsLogger, type: .debug, "\(F.self)", absolutePath, feed.parameters ?? [:])

        guard let request = self.urlRequest(with: absolutePath, parameters: feed.parameters) else { return completionHandler(.failure(.nonFatal)) }

        let dataTask = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completionHandler(.failure(.httpError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                os_log("Error getting data from %@", log: .requestsLogger, type: .error, "\(F.self)")

                completionHandler(.failure(.noContentReturned))
                return
            }

            completionHandler(.success(data))
        })

        dataTask.resume()
    }

    private func urlRequest(with path: String, parameters: [[String: Any]]?) -> URLRequest? {
        guard path.isValidUrl else { return nil }

        var urlComponents = URLComponents(string: path)

        let parameters = parameters?.compactMap({ $0.first.map { URLQueryItem(name: $0.key, value: $0.value as? String) } })
        urlComponents?.queryItems = parameters
        if let url = urlComponents?.url {
            return URLRequest(url: url)
        }

        os_log("malformed url from path %@", log: .requestsLogger, type: .error, path)

        return nil
    }
}
