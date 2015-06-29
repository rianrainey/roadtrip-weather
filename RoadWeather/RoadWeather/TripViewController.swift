//
//  TripViewController.swift
//  RoadWeather
//
//  Created by Rian Rainey on 6/28/15.
//  Copyright (c) 2015 Centresource. All rights reserved.
//

import UIKit

class TripViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var directionsTableView: UITableView!
  @IBOutlet weak var weatherTableView: UITableView!
  @IBOutlet weak var tripSegmentControl: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    directionsTableView.hidden = false
    weatherTableView.hidden = true
      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("directionsCell", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
  }
  
  @IBAction func tripSegmentPressed(sender: UISegmentedControl) {
    println("Sender pressed")
    switch tripSegmentControl.selectedSegmentIndex {
    case 0:
      println("zero")
      directionsTableView.hidden = false
      weatherTableView.hidden = true
    case 1:
      println("one")
      directionsTableView.hidden = true
      weatherTableView.hidden = false
    default:
      break;
    }
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
