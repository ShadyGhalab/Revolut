//
//  CurrencyPairCellViewModel.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import Foundation

private enum Constants {
    static let timeInterval: TimeInterval = 1
    static let timeout: TimeInterval = 30
}

protocol CurrencyPairCellViewInputs {
    func reset()
}

protocol CurrencyPairCellViewOutputs {
    var currencyPair: CurrencyPair { get }
    var updateCurrencyRateIfNeeded: ((String) -> Void)? { get set }
}

protocol CurrencyPairCellViewProtocol: AnyObject {
    var inputs: CurrencyPairCellViewInputs { get }
    var outputs: CurrencyPairCellViewOutputs { get set }
}

final class CurrencyPairCellViewModel: CurrencyPairCellViewInputs, CurrencyPairCellViewOutputs, CurrencyPairCellViewProtocol {

    var inputs: CurrencyPairCellViewInputs { self }
    var outputs: CurrencyPairCellViewOutputs {
        get { self }
        set { }
    }

    private var timer: Timer?
    private var currencyRate: String?
    private let currencyPairRateProvider: CurrencyPairRateProviding
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "concurrentQueue",
                                                             qos: .userInitiated,
                                                             attributes: .concurrent,
                                                             autoreleaseFrequency: .inherit,
                                                             target: nil)

    init(currencyPair: CurrencyPair, currencyPairRateProvider: CurrencyPairRateProviding = CurrencyPairRateProvider(), timerRepeats: Bool = true) {
        self.currencyPairRateProvider = currencyPairRateProvider
        self.currencyPair = currencyPair

        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self,
                                    selector: #selector(fetchCurrencyPairRate), userInfo: nil, repeats: timerRepeats)
    }

    @objc private func fetchCurrencyPairRate() {

        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            self.dispatchGroup.enter()
            self.currencyPairRateProvider.rate(fromCurrencyCode: self.currencyPair.fromCurrencyCode,
                                               toCurrencyCode: self.currencyPair.toCurrencyCode) {
                if let currencyRate = $0?.values.first {
                    self.currencyRate = String(describing: currencyRate.rounded(toPlaces: 4))
                }

                self.dispatchGroup.leave()
            }

            let dispatchTimeoutResult = self.dispatchGroup.wait(timeout: .now() + Constants.timeout)
            if dispatchTimeoutResult == .success, let currencyRate = self.currencyRate {
                DispatchQueue.main.async {
                    self.updateCurrencyRateIfNeeded?(currencyRate)
                }
            }
        }
    }

    func reset() {
        timer?.invalidate()
        timer = nil
    }

    // Outputs
    let currencyPair: CurrencyPair
    var updateCurrencyRateIfNeeded: ((String) -> Void)?
}

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
