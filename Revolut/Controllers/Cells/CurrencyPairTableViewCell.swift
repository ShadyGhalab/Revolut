//
//  CurrencyPairTableViewCell.swift
//  Revolut
//
//  Created by Shady Mustafa on 23.10.19.
//  Copyright © 2019 Revolut Financial. All rights reserved.
//

import UIKit

private enum Constants {
    static let maxDecimalDigitsWithSmallFont = 2
    static let minDigitsToApplySmallFont = 6
    static let fontSize: CGFloat = 12.0
}

class CurrencyPairTableViewCell: UITableViewCell {

    @IBOutlet private weak var fromCurrencyCodeLabel: UILabel!
    @IBOutlet private weak var toCurrencyCodeLabel: UILabel!
    @IBOutlet private weak var fromCurrencyNameLabel: UILabel!
    @IBOutlet private weak var toCurrencyNameLabel: UILabel!

    var viewModel: CurrencyPairCellViewProtocol! {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        fromCurrencyCodeLabel.text = "1 \(viewModel.outputs.currencyPair.fromCurrencyCode )"
        toCurrencyNameLabel.text = viewModel.outputs.currencyPair.toCurrencyName + "  " + viewModel.outputs.currencyPair.toCurrencyCode
        fromCurrencyNameLabel.text = viewModel.outputs.currencyPair.fromCurrencyName

        viewModel.outputs.updateCurrencyRateIfNeeded = { [weak self] rate in
            if rate.count >= Constants.minDigitsToApplySmallFont {
                self?.toCurrencyCodeLabel.attributedText = self?.attributedText(for: rate)
                return
            }

            self?.toCurrencyCodeLabel.text = rate
        }
    }

    private func attributedText(for rate: String) -> NSMutableAttributedString {
        let rateText = NSMutableAttributedString(string: rate)
        let location = rate.index(rate.endIndex, offsetBy: -Constants.maxDecimalDigitsWithSmallFont).utf16Offset(in: rate)
        rateText.setAttributes([.font: UIFont.systemFont(ofSize: Constants.fontSize)],
                                             range: NSRange(location: location, length: Constants.maxDecimalDigitsWithSmallFont))

        return rateText
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel.inputs.prepareForReuse()

        toCurrencyCodeLabel.text = nil
        fromCurrencyCodeLabel.text = nil
        toCurrencyNameLabel.text = nil
        fromCurrencyNameLabel.text = nil
    }
}
