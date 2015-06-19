//
//  TimelineScreen.swift
//  Digicalytics
//
//  Created by Pat McGuire on 6/18/15.
//  Copyright (c) 2015 PatMcGuire. All rights reserved.
//

import Foundation
import Parse

class TimelineScreen: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "sensorDataCell"
    
    var time = ["1:58pm","","","11:49am","","10:15am","","9:59am","9:14am","","","","","","","3:11am","","","1:42am","",""]
    var sensorAction = ["Ready for Demo","","","Start Panicking","","Feeling confident","","Arguing","Beer Fridge","","","","","","","Go to Sleep","","","Leave work","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        var nib = UINib(nibName: "vwTblCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return time.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:customTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! customTableViewCell
        
        
//        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.timeLbl.text = time[row]
        cell.sensorActionLbl.text = sensorAction[row]
        
        if time[row] == ""{
            cell.backgroundImage.image = UIImage(named: "NoData.png")
        }else{
            cell.backgroundImage.image = UIImage(named: "Data.png")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println("Selected \(time[row])")
    }
}