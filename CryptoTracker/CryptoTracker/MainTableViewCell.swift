//
//  MainTableViewCell.swift
//  CryptoTracker
//
//  Created by Viktoriya Voblikova on 9/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var holdingValue: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var latestValue: UILabel!
    @IBOutlet weak var profitLossValue: UILabel!
    @IBOutlet weak var profitLossLabel: UILabel!
    @IBOutlet weak var portValue: UILabel!
    
    var currentValueVar: Double = 1.0
    var currencyType: CurrencyType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
    }
    
    public func getCurrencyType() {
        switch currencyName.text {
        case "Bitcoin": currencyType = .btc
        case "Bitcoin Cash": currencyType = .bch
        case "EOS": currencyType = .eos
        case "Ethereum": currencyType = .eth
        case "Litecoin": currencyType = .ltc
        case "Stellar": currencyType = .xlm
        case "Ripple": currencyType = .xrp
        case "Monero": currencyType = .xmr
        case "NEO": currencyType = .neo
        default: break
        }
    }
    
    public func getCurrentMain(){
//        print("outside hit")
        getCurrencyType()
        
        if let currencyType = currencyType {
            currencyType.requestValue { (valueMain) in
                DispatchQueue.main.async {
                    guard let valueMain = valueMain else {
                        self.currentValue.text = "Failed to get price"
                        return
                    }
//                    print("hit")
                    self.currentValue.text = valueMain.formattedCurrencyString
                }
            }
        }
    }
/*
    func getCurrentVal()->Double{
        getCurrencyType()
                
                if let currencyType = currencyType {
                    currencyType.requestValue { (valueMain) in
                        DispatchQueue.main.async {
                            guard let valueMain = valueMain else {
                                return "Failed to get price"
                            }
                            return valueMain.formattedCurrencyString
                        }
                    }
                }
    }
    */
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
