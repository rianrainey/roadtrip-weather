//
//  SearchResultsTableViewController.swift
//  RoadWeather
//
//  Created by Rian Rainey on 3/23/15.
//  Copyright (c) 2015 Centresource. All rights reserved.
//

import UIKit
import MapKit

class SearchResultsTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    var results:[MKMapItem] = []
//    var destinationSelection:String? = nil
    var selectedDestination:MKMapItem? = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let vc = segue.destinationViewController as? ViewController {
        let indexRow = self.tableView.indexPathForCell(sender as! UITableViewCell)!.row
        vc.selectedDestination = results[indexRow]
      }
    }
  

}
