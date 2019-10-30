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

    @IBOutlet private weak var fromCurrencyRateLabel: UILabel!
    @IBOutlet private weak var toCurrencyRateLabel: UILabel!
    @IBOutlet private weak var fromCurrencyNameLabel: UILabel!
    @IBOutlet private weak var toCurrencyNameLabel: UILabel!

    var viewModel: CurrencyPairCellViewProtocol! {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        fromCurrencyRateLabel.text = "1 \(viewModel.outputs.currencyPair.fromCurrencyCode)"
        toCurrencyNameLabel.text = viewModel.outputs.currencyPair.toCurrencyName + "  " + viewModel.outputs.currencyPair.toCurrencyCode
        fromCurrencyNameLabel.text = viewModel.outputs.currencyPair.fromCurrencyName

        viewModel.outputs.updateCurrencyRateIfNeeded = { [unowned self] currencyRate in
            if currencyRate.count >= Constants.minDigitsToApplySmallFont {
                self.toCurrencyRateLabel.attributedText = self.attributedText(for: currencyRate)
                return
            }

            self.toCurrencyRateLabel.text = currencyRate
        }
    }

    private func attributedText(for string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let location = string.index(string.endIndex, offsetBy: -Constants.maxDecimalDigitsWithSmallFont).utf16Offset(in: string)
        attributedString.setAttributes([.font: UIFont.systemFont(ofSize: Constants.fontSize)],
                                             range: NSRange(location: location, length: Constants.maxDecimalDigitsWithSmallFont))

        return attributedString
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel.inputs.reset()
        toCurrencyRateLabel.text = nil
        fromCurrencyRateLabel.text = nil
        toCurrencyNameLabel.text = nil
        fromCurrencyNameLabel.text = nil
    }

    deinit {
        viewModel.inputs.reset()
    }
}
