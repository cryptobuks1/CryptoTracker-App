//
//  MainViewController.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 5/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//

var portfolio:Double = 0.0
var holdingArray = UserDefaults.standard.array(forKey: "holdings") as! [[String]]

func addHolding(crypto:[String]) {
    var alive:Bool = false
    for i in 0..<holdingArray.count {
        if holdingArray[i][0] == crypto[0] {
            holdingArray[i][1] = String(Double(holdingArray[i][1])! + Double(crypto[1])!)
            holdingArray[i][2] = crypto[2]
            portfolio += Double(crypto[1])! * Double(crypto[2])!
            alive = true
        }
    }
    if alive == false {
    holdingArray.append(crypto)
        portfolio += Double(crypto[1])! * Double(crypto[2])!
    }
   }

func sellHolding(crypto:[String]) {
 var alive:Bool = false
 for i in 0..<holdingArray.count {

     if holdingArray[i][0] == crypto[0] {
        if Double(holdingArray[i][1])! - Double(crypto[1])! == 0 {
            holdingArray.remove(at: i)
        } else {
         holdingArray[i][1] =  String(Double(holdingArray[i][1])! - Double(crypto[1])!)
         holdingArray[i][2] = crypto[2]
         }
         portfolio -= Double(crypto[1])! * Double(crypto[2])!
         alive = true
     }
 }
 if alive == false {
 print("negative holding error")
 }
 print(holdingArray)
}

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var portfolioValue: UILabel!

    @IBOutlet weak var currencyTV: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdingArray.count
    }
    
    //Function that displays data in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTV.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath) as! MainTableViewCell
        //set image
        cell.currencyImage.image = UIImage(named: holdingArray[indexPath.row][0])
        //set Name
        cell.currencyName.text = holdingArray[indexPath.row][0]
        //set Holdings
        cell.holdingValue.text =  String(holdingArray[indexPath.row][1].prefix(6))
       
        cell.getCurrentMain()
        //get the current Value
        cell.latestValue.text = "$" + String(String(holdingArray[indexPath.row][2].prefix(6)))
        //get portfolio value (price bought at * current holdings)
        cell.portValue.text = "$" + (String(Double(holdingArray[indexPath.row][2])! * Double(holdingArray[indexPath.row][1])!).prefix(6))
        cell.profitLossValue.isHidden = true
        cell.profitLossLabel.isHidden = true
        //get the gain/loss of this coin ((price bought at - current price) * holdings)
        /*
        let change:Double = Double(holdingArray[indexPath.row][2])! - Double(cell.currentValue.text)
        if(change > 0){
            cell.profitLossValue.text = ""+String(change * )
        }else{
            cell.profitLossValue.text = "+"+String(change * )
        }
 */
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTV.dataSource = self
        portfolioValue.text = "$" + (String(format: "%.2f",portfolio))
    }

    override func viewDidAppear(_ animated: Bool) {
        portfolioValue.text = "$" + (String(format: "%.2f",portfolio))
        super.viewDidAppear(animated)
        currencyTV.reloadData()
    }

    @IBAction func refreshPort(_ sender: Any) {
        portfolioValue.text = "$" + (String(format: "%.2f",portfolio))
        currencyTV.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addAmountViewController = segue.destination as? AddAmountViewController {
            if let indexPath = currencyTV.indexPathForSelectedRow {
                // THIS CAN BE DONE BETTER
                switch holdingArray[indexPath.row][0] {
                case "Bitcoin": addAmountViewController.currencyType = .btc
                case "Bitcoin Cash": addAmountViewController.currencyType = .bch
                case "EOS": addAmountViewController.currencyType = .eos
                case "Ethereum": addAmountViewController.currencyType = .eth
                case "Litecoin": addAmountViewController.currencyType = .ltc
                case "Stellar": addAmountViewController.currencyType = .xlm
                case "Ripple": addAmountViewController.currencyType = .xrp
                case "Monero": addAmountViewController.currencyType = .xmr
                case "NEO": addAmountViewController.currencyType = .neo
                default: break
                }
            }
        }
    }

}
