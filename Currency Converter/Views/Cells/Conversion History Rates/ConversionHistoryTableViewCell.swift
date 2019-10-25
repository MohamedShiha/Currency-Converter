//
//  ConversionHistoryTableViewCell.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/5/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class ConversionHistoryTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    
    @IBOutlet weak var baseCurrencyImage: UIImageView!
    @IBOutlet weak var baseCurrencyCodeLabel: PaddedLabel!
    @IBOutlet weak var baseAmountLabel: UILabel!
    
    @IBOutlet weak var exchangeAmountLabel: UILabel!
    @IBOutlet weak var exchageCurrencyCodeLabel: PaddedLabel!
    @IBOutlet weak var exchangeCurrencyImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(_ conversion: Conversion) {
        
        let baseCountedCurrency = conversion.baseCountedCurrency
        let exchangeCountedCurrency = conversion.exchangeCountedCurrency
        
        self.baseCurrencyImage.image = baseCountedCurrency?.currency.image
        self.baseCurrencyCodeLabel.text = baseCountedCurrency?.currency.code
        self.baseAmountLabel.text = "\(round(baseCountedCurrency!.amount * 100) / 100)"
        self.exchangeAmountLabel.text = "\(round(exchangeCountedCurrency!.amount * 100) / 100)"
        self.exchageCurrencyCodeLabel.text = exchangeCountedCurrency?.currency.code
        self.exchangeCurrencyImage.image = exchangeCountedCurrency?.currency.image
    }
}
