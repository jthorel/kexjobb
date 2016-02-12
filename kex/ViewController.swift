//
//  ViewController.swift
//  kex
//
//  Created by Johan Thorell on 2016-02-11.
//  Copyright © 2016 Johan Thorell. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    // MARK: Waypoints array
    var locationFirst: CLLocation = CLLocation(latitude: -56.6462520, longitude: -36.6462520)

    
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        print("HeJ")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        label1.text = "\(locationManager.location!)"

    }
    

    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        label2.text = "\(locationManager.heading!.magneticHeading)"
        
    }


}

