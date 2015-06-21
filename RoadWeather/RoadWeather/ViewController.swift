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
  var selectedDestination:MKMapItem? = nil
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var startingTextField: UITextField!
  @IBOutlet weak var destinationTextField: UITextField!
  @IBOutlet weak var startRouteButton: UIButton!
  
//  override func viewDidLayoutSubviews() {
//    destinationTextField.frame.size.height = CGFloat(50.0)
//    var newFrame = destinationTextField.frame
//    newFrame.size.height = CGFloat(50.0)
//    startingTextField.frame = newFrame
    
//    var searchIcon: UILabel
//    searchIcon.text = NSString.init() as String;
//    destinationTextField.leftView =
//    destinationTextField.leftViewMode = UITextFieldViewMode.Always
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
    destinationTextField.delegate = self
    startingTextField.delegate = self
    startingTextField.hidden = true
    hideRouteButton()
    
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
    orientMap(location)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = location.coordinate
    annotation.title = "This is where you are"
    annotation.subtitle = "How did you find me?"
    mapView.addAnnotation(annotation)
  }
  
  func orientMap(location:CLLocation) {
    var coordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    var region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 500)
    mapView.setRegion(region, animated: true)
  }
  
  override func viewWillAppear(animated: Bool) {
    self.results = []
    setupStartRouteButton()
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
  
  func setupStartRouteButton() {
    startRouteButton.layer.cornerRadius = 5
    startRouteButton.layer.borderWidth = 1.0
    startRouteButton.layer.borderColor = self.view.tintColor.CGColor
    startRouteButton.clipsToBounds = true
  }
  
  func showRouteButton() {
    startRouteButton.hidden = false
  }
  
  func hideRouteButton() {
    startRouteButton.hidden = true
  }
  
  @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
    let sourceController: SearchResultsTableViewController = sender.sourceViewController as! SearchResultsTableViewController
    destinationTextField.text = selectedDestination!.name
    
    showRouteButton()
  }

  @IBAction func searchSubmitted(sender: AnyObject) {
    var request = MKLocalSearchRequest()
    request.naturalLanguageQuery = destinationTextField.text
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
  @IBAction func startRoutePressed(sender: AnyObject) {
    
  }
}

