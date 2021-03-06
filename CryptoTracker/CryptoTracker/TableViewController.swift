//
//  TableViewController.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 5/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//
//Instructions and Code partially taken from Max Stein
//https://maxste.in/build-an-ethereum-bitcoin-price-tracking-app-in-swift-f467b7f3ae35

import UIKit

class TableViewController: UITableViewController {

    let currencies: [CurrencyType] = [.btc, .bch, .eos, .eth, .ltc, .xlm, .xrp, .xmr, .neo]
       let reuseIdentifier = String(describing: CryptoTableViewCell.self)
       
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return currencies.count
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
           
           if let cryptoTableViewCell = tableViewCell as? CryptoTableViewCell {
               let currencyType = currencies[indexPath.row]
               cryptoTableViewCell.formatCell(withCurrencyType: currencyType)
           }
           
           return tableViewCell
       }
       
       override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return "Cryptocurrency Prices"
       }
       
       override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .long
           dateFormatter.timeStyle = .medium
           let date = Date()
           let dateString = dateFormatter.string(from: date)
           return "Updated on " + dateString
       }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addAmountViewController = segue.destination as? AddAmountViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let currencyType = currencies[indexPath.row]
                addAmountViewController.currencyType = currencyType
            }
        }
    }
    
 }
