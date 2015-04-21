//
//  ViewController.swift
//  RoadWeather
//
//  Created by Rian Rainey on 3/11/15.
//  Copyright (c) 2015 Centresource. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

  var results:[MKMapItem] = []
  var destinationSelection:String? = nil
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var fromText: UITextField!
  @IBOutlet weak var toText: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    toText.delegate = self
    fromText.delegate = self
    
    ///////////////////////////
    // Display Current Location
    ///////////////////////////
    let locationManager = appDelegate.locationManager
    locationManager.startUpdatingLocation()
    
    var location = locationManager.location
    locationManager.stopUpdatingLocation()
    
    if location == nil {
      location = CLLocation(latitude: 36.177846, longitude: -86.788432) // Nashville
    }
    
    mapView.showsUserLocation = true
    
    var coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    var region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 500)
    mapView.setRegion(region, animated: true)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = location.coordinate
    annotation.title = "This is where you are"
    annotation.subtitle = "How did you find me?"
    mapView.addAnnotation(annotation)
  }
  
  override func viewWillAppear(animated: Bool) {
    self.results = []
    toText.text = destinationSelection
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "searchResultsSegue" {
      if let vc = segue.destinationViewController as? SearchResultsTableViewController { 
        vc.results = results
      }
    }
  }
  
  @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
    let sourceController: AnyObject = sender.sourceViewController
    toText.text = destinationSelection
  }

  @IBAction func searchSubmitted(sender: AnyObject) {
    var request = MKLocalSearchRequest()
    request.naturalLanguageQuery = toText.text
    var localSearch = MKLocalSearch(request: request)
    localSearch.startWithCompletionHandler { (response:MKLocalSearchResponse!, e:NSError!) -> Void in
      if e == nil {
        for item in response.mapItems {
          println("Item name = \(item.name)")
          self.results.append(item as! MKMapItem)
        }
        self.performSegueWithIdentifier("searchResultsSegue", sender: self)
      }
      else {
        println("Error")
      }
    }
    
    
    // Else, somehow say no results and have them search again
  }
}

