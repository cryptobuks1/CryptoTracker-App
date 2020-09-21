//
//  AddAmountViewController.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 5/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//


import UIKit

class AddAmountViewController: UIViewController {
    
    var currencyType : CurrencyType?
    
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyPrice: UILabel!
    @IBOutlet weak var cryptoAUD: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var holdingsVal: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var portLabel: UILabel!
    
    @IBOutlet weak var stepperThousands: UIStepper!
    @IBOutlet weak var stepperHundreds: UIStepper!
    @IBOutlet weak var stepperTenners: UIStepper!
    @IBOutlet weak var stepperDollars: UIStepper!
    
    var holdingDol: Double = 0.0
    var dollars: Double = 0.0
    var tenners: Double = 0.0
    var hundreds: Double = 0.0
    var thousands: Double = 0.0
    var moneyVal: Double = 0.0
    var cryptoVal: Double = 0.0
    var holdingTemp: Double = 0.0
    
    override func viewDidLoad() {
        updateCrypto()
        updateHolding()
        canSell()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCrypto()
        updateHolding()
        canSell()
        super.viewDidAppear(animated)
    }
    
    func updateCrypto() {
        if let currencyType = currencyType {
            currencyName.text = currencyType.name
            
            currencyType.requestValue { (value) in
                DispatchQueue.main.async {
                    guard let value = value else {
                        self.currencyPrice.text = "Failed to get price"
                        return
                    }
                    self.currencyPrice.text = value.formattedCurrencyString
                    self.cryptoVal = Double(value)

                }
            }
        }
    }
    
    func updateHolding() {
        
        for i in 0..<holdingArray.count {
            if holdingArray[i][0] == currencyName.text {
                holdingsVal.text = String(holdingArray[i][1].prefix(6))
                holdingTemp = Double(holdingArray[i][1])!
                portLabel.text = "$\(String(format: "%.2f", holdingTemp * cryptoVal))"
            }
        }
    }
    
    func canSell(){
        if holdingTemp >= (moneyVal / cryptoVal) && holdingTemp > 0.0 && (moneyVal / cryptoVal) > 0.0{
            sellButton.isEnabled = true
        }
        else {
            sellButton.isEnabled = false
        }
    }
    
    @IBAction func steppers(_ sender: UIStepper) {
        switch sender.tag {
        case 1: thousands = sender.value
        case 2: hundreds = sender.value
        case 3: tenners = sender.value
        case 4: dollars = sender.value
        default: break
        }
        moneyVal = dollars + (thousands*1000) + (hundreds*100) + (tenners*10)
        amount.text = "$\(String(moneyVal))"
        cryptoMaths()
        canSell()
    }
    
    @IBAction func goHome(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func cryptoMaths(){
        cryptoAUD.text = String(String(moneyVal / cryptoVal).prefix(6))
    }
    
    @IBAction func buyCrypto(_ sender: Any) {
        //holdingDol = holdingDol + moneyVal
        holdingsVal.text = String(String(moneyVal / cryptoVal).prefix(6))
        let newHolding: [String] = [currencyName.text ?? "error", String(moneyVal / cryptoVal), String(cryptoVal)]
        addHolding(crypto: newHolding)
        updateHolding()
        canSell()
    }
    
    @IBAction func selCrypto(_ sender: Any) {
        //holdingDol = holdingDol - moneyVal
        holdingsVal.text = String(String(moneyVal / cryptoVal).prefix(6))
        let newHolding: [String] = [currencyName.text ?? "error", String(moneyVal / cryptoVal), String(cryptoVal)]
        sellHolding(crypto: newHolding)
        if (moneyVal / cryptoVal) == holdingTemp {
            //wipe
            holdingsVal.text = "0.0"
            portLabel.text = "0.0"
            holdingTemp = 0.0
        }
        updateHolding()
        canSell()
    }
    
    @IBAction func eraseButton(_ sender: UIButton) {
        dollars = 0
        tenners = 0
        hundreds = 0
        thousands = 0
        stepperThousands.value = 0
        stepperHundreds.value = 0
        stepperTenners.value = 0
        stepperDollars.value = 0
        moneyVal = 0.0
        amount.text = "$0.00"
        cryptoMaths()
        canSell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let trackingViewController  = segue.destination as? TrackingViewController {
            if let currencyTypeTrack = currencyType {
                trackingViewController.currencyType = currencyType
            }
        }
    }

}

//Code taken from Max Stein
//https://maxste.in/build-an-ethereum-bitcoin-price-tracking-app-in-swift-f467b7f3ae35
public  extension NSNumber {
    var formattedCurrencyString: String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_AU")
        formatter.numberStyle = .currency
        
        guard let formattedCurrencyAmount = formatter.string(from: self) else {
            return nil
        }
        return formattedCurrencyAmount
    }
    
}
