//
//  StartViewController.swift
//  CryptoTracker
//
//  Created by Viktoriya Voblikova on 10/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//

import UIKit

class StartViewController: UINavigationController {

    var holdingArray: [[String]] = [] //[["Bitcoin", "1", "9,680"], ["Example", "345", "23.95"]]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(holdingArray, forKey: "holdings")
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
