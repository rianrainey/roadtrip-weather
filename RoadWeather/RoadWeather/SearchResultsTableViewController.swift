//
//  SearchResultsTableViewController.swift
//  RoadWeather
//
//  Created by Rian Rainey on 3/23/15.
//  Copyright (c) 2015 Centresource. All rights reserved.
//

import UIKit
import MapKit

class SearchResultsTableViewController: UITableViewController {
    var results:[MKMapItem] = []
    var destinationSelection:String? = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return results.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mapResultsIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let mapItem = results[indexPath.row]
        cell.textLabel?.text = mapItem.name

        return cell
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//      return results[indexPath.row].name
      let indexPath = tableView.indexPathForSelectedRow();
      let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
      destinationSelection == currentCell.textLabel?.text
      
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let vc = segue.destinationViewController as? ViewController {
        vc.destinationSelection = sender?.textLabel??.text
      }
    }
  

}
