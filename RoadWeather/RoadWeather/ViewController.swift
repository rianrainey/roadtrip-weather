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
//import FontAwesome_swift

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var currentLocation:CLLocation? = nil
  var results:[MKMapItem] = []
  var selectedDestination:MKMapItem? = nil
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var startingTextField: UITextField!
  @IBOutlet weak var destinationTextField: UITextField!
  @IBOutlet weak var startRouteButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideNavigationBar()
    destinationTextField.delegate = self
    startingTextField.delegate = self
    startingTextField.hidden = true
    mapView.delegate = self
    hideRouteButton()
    
    ///////////////////////////
    // Display Current Location
    ///////////////////////////
    let locationManager = appDelegate.locationManager
    locationManager.startUpdatingLocation()
    currentLocation = locationManager.location
    locationManager.stopUpdatingLocation()
    
    if currentLocation == nil {
      currentLocation = CLLocation(latitude: 36.177846, longitude: -86.788432) // Nashville
    }
    
    mapView.showsUserLocation = true
    orientMap(currentLocation!)
    
    var annotation = MKPointAnnotation()
    annotation.coordinate = currentLocation!.coordinate
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
  
  // MARK: - View Methods
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
  
  func hideNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  // MARK: - IBActions
  @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
    let sourceController: SearchResultsTableViewController = sender.sourceViewController as! SearchResultsTableViewController
    destinationTextField.text = selectedDestination!.name
    
    showRouteButton()
    hideNavigationBar()
    getDirections()
    mapView.removeOverlays(mapView.overlays)
    mapView.removeAnnotations(mapView.annotations)
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
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if annotation is MKUserLocation {
      //return nil so map view draws "blue dot" for standard user location
      return nil
    }
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.animatesDrop = true
      pinView!.pinColor = .Purple
    }
    else {
      pinView!.annotation = annotation
    }
    
    return pinView
  }
  
  func getDirections() {
    let request = MKDirectionsRequest()
    var current2D = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
    var currentPlacemark = MKPlacemark(coordinate: current2D, addressDictionary: nil)
    var currentMapItem = MKMapItem(placemark: currentPlacemark)
    request.setSource(currentMapItem)
    request.setDestination(selectedDestination)
    request.requestsAlternateRoutes = false
    
    let directions = MKDirections(request: request)
    
    directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
      if error != nil {
        println("There was an error: #{error}")
      } else {
        println("SUCCESS!")
        self.showRoute(response)
      }
    })
  }
  
  func showRoute(response: MKDirectionsResponse) {
    for route in response.routes as! [MKRoute] {
      mapView.addOverlay(route.polyline,
        level: MKOverlayLevel.AboveRoads)
      
      for step in route.steps {
        println(step.instructions)
      }
    }
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = selectedDestination!.placemark.coordinate
    annotation.title = "This is where you are"
    annotation.subtitle = "How did you find me?"
    mapView.addAnnotation(annotation)
    
    mapView.showAnnotations(mapView.annotations, animated: true)
  }
  
  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
      let renderer = MKPolylineRenderer(overlay: overlay)
      
      renderer.strokeColor = UIColor.blueColor()
      renderer.lineWidth = 5.0
      return renderer
  }
}

