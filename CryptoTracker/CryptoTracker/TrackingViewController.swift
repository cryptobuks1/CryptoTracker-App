//
//  TrackingViewController.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 5/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//
struct crypto2Track {
    var Crypto: String
    var greaterLesserTrack: Int
    var xValueTrack: Double
}

var trackingArray: [crypto2Track] = []

import UIKit

class TrackingViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var stepperThousands: UIStepper!
    @IBOutlet weak var stepperHundreds: UIStepper!
    @IBOutlet weak var stepperTenners: UIStepper!
    @IBOutlet weak var stepperDollars: UIStepper!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var belowOver: UISegmentedControl!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var trackingTV: UITableView!
    
    var currencyType : CurrencyType?
    var holdingDol: Double = 0.0
    var cents: Double = 0.0
    var tenCents: Double = 0.0
    var dollars: Double = 0.0
    var tenners: Double = 0.0
    var hundreds: Double = 0.0
    var thousands: Double = 0.0
    var moneyVal: Double = 0.0
    var cryptoVal: Double = 0.0
    var holdingTemp: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackingTV.dataSource = self
        updateCrypto()
        
        /*
        let centre = UNUserNotificationCenter.current()
        centre.requestAuthorization(options: [.alert, .sound]) { (granted, Error) in
        }
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body body body"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "done", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
         */
        // Do any additional setup after loading the view.
    }
    
    var timer = Timer()

    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.priceNoti), userInfo: nil, repeats: true)
    }


    
    @objc func priceNoti() {
        for i in 0..<trackingArray.count {
            if trackingArray[i].Crypto == currencyName.text {
            var canRemove: Bool = false
                if trackingArray[i].greaterLesserTrack == 0 {
                    if trackingArray[i].xValueTrack < cryptoVal {
                        let alertView = UIAlertController(title: "\(trackingArray[i].Crypto) Price Alert", message: "\(trackingArray[i].Crypto)'s current price is greater than \(trackingArray[i].xValueTrack)", preferredStyle: UIAlertController.Style.alert)
                        alertView.addAction(UIAlertAction(title: "Go", style: UIAlertAction.Style.default, handler: nil))
                        present(alertView, animated: true, completion: nil)
                        canRemove = true
                    }
                }
                if trackingArray[i].greaterLesserTrack == 1 {
                    if trackingArray[i].xValueTrack > cryptoVal {
                        let alertView = UIAlertController(title: "\(trackingArray[i].Crypto) Price Alert", message: "\(trackingArray[i].Crypto)'s current price is less than \(trackingArray[i].xValueTrack)", preferredStyle: UIAlertController.Style.alert)
                        alertView.addAction(UIAlertAction(title: "Go", style: UIAlertAction.Style.default, handler: nil))
                        present(alertView, animated: true, completion: nil)
                        canRemove = true
                    }
                }
                if canRemove == true {
                    trackingArray.remove(at: i)
                }
            }
        }
    }
    
    @IBAction func steppers(_ sender: UIStepper) {
        switch sender.tag {
        case 1: thousands = sender.value
        case 2: hundreds = sender.value
        case 3: tenners = sender.value
        case 4: dollars = sender.value
        case 5: tenCents = sender.value
        case 6: cents = sender.value
        default: break
        }
        moneyVal = dollars + (thousands*1000) + (hundreds*100) + (tenners*10) + (tenCents*0.10) + (cents*0.01)
        amount.text = "$\(String(moneyVal))"
    }

    func updateCrypto() {
        if let currencyType = currencyType {
            currencyName.text = currencyType.name
            currencyType.requestValue { (value) in
                DispatchQueue.main.async {
                    guard let value = value else {
                        self.currentPrice.text = "Failed to get price"
                        return
                    }
                    self.currentPrice.text = value.formattedCurrencyString
                    self.cryptoVal = Double(value)
                }
            }
        }
    }
    
    @IBAction func addTrack(_ sender: Any) {
        let greaterLesser = belowOver.selectedSegmentIndex
        let xPrice = moneyVal
        let newTrack = crypto2Track(Crypto: currencyName.text ?? "error", greaterLesserTrack: greaterLesser, xValueTrack: xPrice)
        trackingArray.append(newTrack)
        print(trackingArray)
            scheduledTimerWithTimeInterval()
        
        trackingTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows: Int = 0
            for i in 0..<trackingArray.count {
                if trackingArray[i].Crypto == currencyName.text {
                    numberRows = numberRows + 1
                }
            }
        return numberRows
       }
       
       //Function that displays data in the cells
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        for i in 0..<trackingArray.count {
            if trackingArray[i].Crypto == currencyName.text {
        
                let cell = trackingTV.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackingTableViewCell
                
                let inter = trackingArray[indexPath.row].greaterLesserTrack
                
                if inter == 0{
                    cell.greatLess.text = "Greater"
                }
                if inter == 1{
                    cell.greatLess.text = "Lesser"
                }
                cell.xValue.text = String(trackingArray[indexPath.row].xValueTrack)

                   return cell
            }
       }
        
        let cellBlank = trackingTV.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackingTableViewCell
        
        return cellBlank
        
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
