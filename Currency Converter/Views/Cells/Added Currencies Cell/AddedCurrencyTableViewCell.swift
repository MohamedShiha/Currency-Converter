//
//  AddedCurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by Mohamed Shiha on 9/3/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class AddedCurrencyTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var exchangeCurrencyCode: UILabel!
    @IBOutlet weak var exchangeCurrencyName: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(_ countedCurrency : CountedCurrency) {
        self.currencyImage.image = countedCurrency.currency.image
        self.exchangeCurrencyCode.text = countedCurrency.currency.code
        self.exchangeCurrencyName.text = countedCurrency.currency.name
        self.amount.text = "\(countedCurrency.amount ?? 0)"
    }
}
