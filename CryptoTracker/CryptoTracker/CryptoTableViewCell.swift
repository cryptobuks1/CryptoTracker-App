//
//  CryptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 9/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//
//Instructions and Code partially taken from Max Stein
//https://maxste.in/build-an-ethereum-bitcoin-price-tracking-app-in-swift-f467b7f3ae35

import UIKit

class CryptoTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyPrice: UILabel!
    
    func formatCell(withCurrencyType currencyType: CurrencyType) {
        currencyName.text = currencyType.name
        currencyImageView.image = currencyType.image
        
        currencyType.requestValue { (value) in
            DispatchQueue.main.async {
                guard let value = value else {
                    self.currencyPrice.text = "Failed to get price"
                    return
                }
                self.currencyPrice.text = value.formattedCurrencyString
            }
        }
    }

}
