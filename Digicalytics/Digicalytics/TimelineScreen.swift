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
    
    let formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm aa"
        return formatter
    }()
    
    var buttons : [Button] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "sensorDataCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var nib = UINib(nibName: "vwTblCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        getParseData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buttons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:customTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as customTableViewCell
        
        var button = self.buttons[indexPath.row]
        cell.timeLbl.text = self.formatter.stringFromDate(button.createdAt)
        cell.sensorActionLbl.attributedText = makeAttributed(button.sensorID)
        
        return cell
    }
    
    //MARK: - UIButton Delegates
    
    func makeAttributed(old : NSString) -> NSMutableAttributedString {


        let fontSize : CGFloat = 13.0;
        let boldFont = UIFont.boldSystemFontOfSize(fontSize)
        let regularFont = UIFont.systemFontOfSize(fontSize)
        let foregroundColor = UIColor.blackColor()
        let attrs = [NSFontAttributeName : boldFont, NSForegroundColorAttributeName : foregroundColor]
        let subAttrs = [NSFontAttributeName : regularFont]

        let range = old.rangeOfString(" ")
        
        let s = NSMutableAttributedString(string: old, attributes: attrs)
        s.setAttributes(subAttrs, range: range)
        return s
    }
    
    @IBAction func addSensor(sender: AnyObject) {
        println("Add Button Pressed!")
    }
    
    func getParseData() {
        
        var query = PFQuery(className:"button")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("Error: \(error!) \(error!.userInfo!)")
                return
            }
            
            var buttons : [Button] = []
            
            if let objects = objects as? [PFObject] {
                for object in objects {
                    println(object)
                    buttons.append(Button(sensorID: object["sensorID"] as Int, createdAt: object.createdAt))
                }
            }
            self.buttons = buttons
            self.tableView.reloadData()
        }
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "getNewParseData", userInfo: nil, repeats: true)
    }
    func getNewParseData(){

        let query = PFQuery(className: "button")
        if let first = self.buttons.first {
            query.whereKey("createdAt", greaterThan: first)
        }
        else {
            return
        }
        query.orderByDescending("createAt")
        query.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]?, error: NSError?) -> Void in
        
            if error != nil {
                println("could not fetch new parse data.")
            }
            for object in objects as [PFObject] {
                if let object = objects?.first as? PFObject {
                    self.buttons.insert(Button(sensorID: object["sensorId"] as Int, createdAt: object.createdAt), atIndex: 0)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }

    }
}
}
class Button {
    let sensorID : String
    let createdAt: NSDate
    init(sensorID : Int, createdAt: NSDate) {
        self.sensorID = ["OpenDoor", "Open Cabinet", "Turn On Light", "Take Medicine"][sensorID]
        self.createdAt = createdAt
    }
}
