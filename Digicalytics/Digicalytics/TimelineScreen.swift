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
    
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "sensorDataCell"
    
    let actionValues = ["OpenDoor", "Open Cabinet", "Turn On Light", "Take Medicine"]
    
//    var time = ["1:58pm","","","11:49am","","10:15am","","9:59am","9:14am","","","","","","","3:11am","","","1:42am","",""]
    
    var time: [NSDate?] = []
    
    var action: [String] = []
    
//    var sensorAction = ["Ready for Demo","","","Start Panicking","","Feeling confident","","Arguing","Beer Fridge","","","","","","","Go to Sleep","","","Leave work","",""]
    
    func setBackground() {
    
    let backgroundImageView : UIImageView = UIImageView()
    
    self.view.addSubview(backgroundImageView)
    
    TimelineScreen.inflateView(backgroundImageView, toParent: self.view)
    
    backgroundImageView.image = UIImage(named: "event_background");
    
    
    }
    
    func getParseData() {
        var query = PFQuery(className:"button")
//        query.whereKey("type", equalTo:"Door")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) datapoints.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for i in 0 ..< objects.count {
                        let object = objects[i]
//                        println(object["Time"])

//                        println("\(str)")
                        
                        var iD = object["sensorID"] as! Int
//                        println()
//                        var addTime = object["Time"] as! String
                        var addAction = self.actionValues[iD]
                        
                        
                        
                        self.time.append(object.createdAt)
                        self.action.append(addAction)
                        
                        // if this isn't the last index then check the time of the next object
                        if i != objects.count - 1 {
                            let object2 = objects[i+1]
                            
                            let cal = NSCalendar.currentCalendar()
                            
                            let comps = cal.components(NSCalendarUnit.CalendarUnitHour, fromDate: object2.createdAt!, toDate: object.createdAt!, options: nil)
                            for j in 0..<comps.hour {
                                self.time.append(nil)
                                self.action.append("")
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            
            
            
            self.tableView.reloadData()
            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "getNewParseData", userInfo: nil, repeats: true)
        }
    }
    
    func getNewParseData(){
        
        let query = PFQuery(className: "button")
        query.whereKey("createdAt", greaterThan: time[0]!)
        query.orderByDescending("createAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let object = objects?.first as? PFObject {
                    self.time.insert(object.createdAt, atIndex: 0)
                    self.action.insert(self.actionValues[object["sensorID"] as! Int], atIndex: 0)
                    
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }else{
                println("could not fetch new parse data.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getParseData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        
        self.setBackground()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "event_background")!)
        
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
        
        cell.backgroundColor = UIColor.clearColor()
        
//        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        
        if let date = time[row]{
            cell.timeLbl.text = formatter.stringFromDate(date)
        } else {
            cell.timeLbl.text = nil
        }
        cell.sensorActionLbl.text = action[row]
        
        if time[row] == nil{
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
    
    //MARK: - UIButton Delegates
    
    @IBAction func addSensor(sender: AnyObject) {
        println("Add Button Pressed!")
    }
    
    /// "Inflates" the given view to fill the given parentView.
    ///
    /// It's advised to have the view as the sole child of the parentView.
    ///
    /// :param: view The child view to "inflate"
    /// :param: parentView The parent to which the child will fill.
    class func inflateView(view: UIView, toParent parentView: UIView) {
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["view":view]))
        
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["view":view]))
    }
    
}