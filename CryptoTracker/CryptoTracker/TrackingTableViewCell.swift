//
//  TrackingTableViewCell.swift
//  CryptoTracker
//
//  Created by Max Simons on 11/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//

import UIKit

class TrackingTableViewCell: UITableViewCell {
    @IBOutlet weak var greatLess: UILabel!
    @IBOutlet weak var xValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
