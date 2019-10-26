//
//  OSLog+Loggers.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation
import os.log

extension OSLog {

    private static let subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

    static let modelsLogger = OSLog(subsystem: OSLog.subsystem, category: "Models")
    static let requestsLogger = OSLog(subsystem: OSLog.subsystem, category: "Requests")
}
