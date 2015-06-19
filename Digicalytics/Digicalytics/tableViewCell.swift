//
//  tableViewCell.swift
//  Digicalytics
//
//  Created by Pat McGuire on 6/18/15.
//  Copyright (c) 2015 PatMcGuire. All rights reserved.
//

import Foundation
import Parse

class customTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!

    @IBOutlet weak var sensorActionLbl: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var bubbleView: UIImageView!
    
    @IBOutlet weak var clockIcon: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = UIImage(named: "ic_Clock") {
            clockIcon.image = image;
        }
        
        if let background = UIImage(named: "bubble.png") {
            bubbleView.image = background
        }
    }
}