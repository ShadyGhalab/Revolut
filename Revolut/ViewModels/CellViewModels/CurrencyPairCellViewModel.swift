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
}

protocol CurrencyPairCellViewInputs {
    func prepareForReuse()
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

    var inputs: CurrencyPairCellViewInputs { return self }
    var outputs: CurrencyPairCellViewOutputs {
        set { }
        get { return self }
    }

    private let currencyPairRateProvider: CurrencyPairRateProviding
    private var time: Timer?
    private var isRateBeingFetched: Bool = false
    private var currencyRate: String? {
        willSet {
            if let newRate = newValue, newRate != currencyRate {
                updateCurrencyRateIfNeeded?(newRate)
            }
        }
    }

    init(currencyPair: CurrencyPair, currencyPairRateProvider: CurrencyPairRateProviding = CurrencyPairRateProvider(), timerRepeats: Bool = true) {
        self.currencyPairRateProvider = currencyPairRateProvider
        self.currencyPair = currencyPair

        time = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self,
                                    selector: #selector(fetchCurrencyPairRate), userInfo: nil, repeats: timerRepeats)
    }

    @objc private func fetchCurrencyPairRate() {
        guard !isRateBeingFetched  else { return }

        isRateBeingFetched = true
        currencyPairRateProvider.rates(fromCurrencyCode: currencyPair.fromCurrencyCode,
                                    toCurrencyCode: currencyPair.toCurrencyCode) { [weak self] currencyRate in
                DispatchQueue.main.async {
                    if let currencyRate: Double = currencyRate?.values.first {
                        self?.currencyRate = String(describing: currencyRate.rounded(toPlaces: 4))
                    }
                }

                self?.isRateBeingFetched = false
        }
    }

    func prepareForReuse() {
        time?.invalidate()
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
