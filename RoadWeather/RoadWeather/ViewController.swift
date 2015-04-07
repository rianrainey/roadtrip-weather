//
//  ViewController.swift
//  RoadWeather
//
//  Created by Rian Rainey on 3/11/15.
//  Copyright (c) 2015 Centresource. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
  var results = [] as [MKMapItem]
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var locationText: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let location = CLLocationCoordinate2D(
      latitude: 36.177846,
      longitude: -86.788432
    )
    
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
      
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    annotation.title = "CentreSource"
    annotation.subtitle = "Nashville"
    mapView.addAnnotation(annotation)
    
    self.locationText.delegate = self;
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func zoomIn(sender: AnyObject) {
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "searchResultsSegue" {
      if let vc = segue.destinationViewController as? SearchResultsTableViewController { 
        vc.results = results
      }
    }
  }

  @IBAction func searchSubmitted(sender: AnyObject) {
    // If results, prepareforsegue to SearchResultsTableViewController
    var request = MKLocalSearchRequest()
    request.naturalLanguageQuery = locationText.text
    var localSearch = MKLocalSearch(request: request)
    localSearch.startWithCompletionHandler { (response:MKLocalSearchResponse!, e:NSError!) -> Void in
      if e == nil {
        for item in response.mapItems {
          println("Item name = \(item.name)")
          self.results.append(item as! MKMapItem)
        }
        self.performSegueWithIdentifier("searchResultsSegue", sender: self)
//        SearchResultsTableViewController.prepareForSegue(<#UIViewController#>)
//        SearchResultsTableViewController.prepareForSegue(<#SearchResultsTableViewController#>) //Wi('searchResultsSegue', sender: self)
        
        
      }
      else {
        println("Error")
      }
    }
    
    
    // Else, somehow say no results and have them search again
  }
}

